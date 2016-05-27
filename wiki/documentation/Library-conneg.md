---
layout: default
title: Library conneg
base_url: ../../../
---
# Server-driven content negotiation

EWF supports server-driven content content negotiation, as defined in [HTTP/1.1 Content Negotiation](http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.1) . To enable this facility:

1. Add ${EWF}/library/network/protocol/conneg/conneg.ecf to your system ECF.
1. In the class where your handlers reside, add an attribute `conneg: CONNEG_SERVER_SIDE`, and ensure it is always attached (create in the creation procedure, or make it a once, or add an attribute body). An example creation call is: `create conneg.make ({HTTP_MIME_TYPES}.application_json, "en", "UTF-8", "")`. 

That call defines our defaults for media-type, language, charset and encoding, respectively. The encoding could also be written as `"identity"`. It means no compression. As an alternative, we might code `"gzip"`.

The user agent (a web browser, for example. or the curl program), can request different representations by using headers. For example, `Accept: application/json; q=0.2, application/xml` says the client would be very happy to get back an XML representation (if you omit the q for quality parameter, it defaults to 1, which is best), but (s)he will tolerate JSON. Clearly, we are going to be able to satisfy that client, as we serve JSON by default. But what if the client had requested `Accept: application/xml;q=0.8, text/html`? In this example, we are going to serve both JSON and XML representations upon request. A client who requests `Accept: text/html, text/plain` is going to be disappointed. For the other aspects (language, charset and encoding), we are not going to offer any choices. That does not mean we ignore the client's headers for these aspects. We are going to check if our representation is acceptable to the client, and if not, return a 406 Not Acceptable response (an alternative is to send our representation anyway, and let the user decide whether or not to use it).

Next, we need to declare all the representations we support:

	mime_types_supported: LINKED_LIST [STRING] is
			-- Media types `Current' supports
		once
			create Result.make
			Result.put_front ({HTTP_MIME_TYPES}.application_xml)
			Result.put_front ({HTTP_MIME_TYPES}.application_json)
		ensure
			mime_types_supported_not_void: Result /= Void
			no_void_entry: not Result.has (Void)
		end

	charsets_supported: LINKED_LIST [STRING] is
			-- Character sets `Current' supports
		once
			create Result.make
			Result.put_front ("UTF-8")
		ensure
			charsets_supported_not_void: Result /= Void
			no_void_entry: not Result.has (Void)
		end
	
	encodings_supported: LINKED_LIST [STRING] is
			-- Encodings `Current' supports
		once
			create Result.make
			Result.put_front ("identity")
			Result.put_front ("") -- identity encoding
		ensure
			encoding_supported_not_void: Result /= Void
			no_void_entry: not Result.has (Void)
		end

	languages_supported: LINKED_LIST [STRING] is
			-- Languages `Current' supports
		once
			create Result.make
			Result.put_front ("en")
		ensure
			languages_supported_not_void: Result /= Void
			no_void_entry: not Result.has (Void)
		end

Now we are in a position to do some negotiating. At the beginning of your handler(s), code:


    local
			l_media_variants: MEDIA_TYPE_VARIANT_RESULTS
                        l_is_head: BOOLEAN
                        h: HTTP_HEADER
                        l_msg: STRING
		do
                        l_is_head := False -- or `True' if this is for a HEAD handler
			l_media_variants:= conneg.media_type_preference (mime_types_supported, a_req.http_accept)
			if not l_media_variants.is_acceptable then
				send_unacceptable_media_type (a_res, l_is_head)
		 	elseif not conneg.charset_preference (charsets_supported, a_req.http_accept_charset).is_acceptable then
 				send_unacceptable_charset (a_res, l_is_head)
 			elseif not conneg.encoding_preference (encodings_supported, a_req.http_accept_encoding).is_acceptable then
 				send_unacceptable_encoding (a_res, l_is_head)
 			elseif not conneg.language_preference (languages_supported, a_req.http_accept_language).is_acceptable then
 				send_unacceptable_encoding (a_res)
			else
                          -- We have agreed a representation, let's go and serve it to the client
`

Now for those `send_unnacceptable_...` routines. They are fairly simple:

    	send_unacceptable_media_type (a_res: WSF_RESPONSE; a_is_head: BOOLEAN) is
			-- Send error result as text/plain that the media type is unnacceptable.
		require
			a_res_not_void: a_res /= Void
			status_not_set: not a_res.status_is_set
			header_not_committed: not a_res.header_committed
		local
			l_error_text: STRING
		do
			l_error_text := "The requested media type(s) is/are not supported by this server."
			send_unacceptable (a_res, a_is_head, l_error_text)
		end

	send_unacceptable_charset (a_res: WSF_RESPONSE; a_is_head: BOOLEAN) is
			-- Send error result as text/plain that the character set is unnacceptable.
		require
			a_res_not_void: a_res /= Void
			status_not_set: not a_res.status_is_set
			header_not_committed: not a_res.header_committed
		local
			l_error_text: STRING
		do
			l_error_text := "The requested character set(s) is/are not supported by this server. Only UTF-8 is supported."
			send_unacceptable (a_res, a_is_head, l_error_text)
		end

	send_unacceptable_encoding (a_res: WSF_RESPONSE; a_is_head: BOOLEAN) is
			-- Send error result as text/plain that the encoding is unnacceptable.
		require
			a_res_not_void: a_res /= Void
			status_not_set: not a_res.status_is_set
			header_not_committed: not a_res.header_committed
		local
			l_error_text: STRING
		do
			l_error_text := "The requested encoding(s) is/are not supported by this server. Only identity is supported."
			send_unacceptable (a_res, a_is_head, l_error_text)
		end

	send_unacceptable_language (a_res: WSF_RESPONSE; a_is_head: BOOLEAN) is
			-- Send error result as text/plain that the language unnacceptable.
		require
			a_res_not_void: a_res /= Void
			status_not_set: not a_res.status_is_set
			header_not_committed: not a_res.header_committed
		local
			l_error_text: STRING
		do
			l_error_text := "The requested language(s) is/are not supported by this server. Only en (English) is supported."
			send_unacceptable (a_res, a_is_head, l_error_text)
		end
	
	send_unacceptable (a_res: WSF_RESPONSE; a_is_head: BOOLEAN; a_error_text: STRING) is
			-- Send a_error_text as text/plain that a header is unnacceptable.
		require
			a_res_not_void: a_res /= Void
			status_not_set: not a_res.status_is_set
			header_not_committed: not a_res.header_committed
			a_error_text_not_void: a_error_text /= Void
		local
			h: HTTP_HEADER
		do
			create h.make
			set_content_type (h, Void)
			h.put_content_length (a_error_text.count)
			h.put_current_date
			a_res.set_status_code ({HTTP_STATUS_CODE}.not_acceptable)
			a_res.put_header_text (h.string)
			if not a_is_head then
				a_res.put_string (a_error_text)
			end
		end

We'll see that `set_content_type` routine in a bit. But for now, we just have to generate the response. Let's go back to that `else ...` bit:

    else
                       -- We have agreed a representation, let's go and serve it to the client
	create h.make
	set_content_type (h, a_media_variants)
       	if a_media_variants.media_type ~ {HTTP_MIME_TYPES}.application_xml then
		l_msg := "<?xml version='1.0' encoding='UTF-8' ?><my-tag>etc."
	else
		l_msg := json.value (<some-value>).representation
	end
	h.put_content_length (l_msg.count)
	h.put_current_date
	a_res.set_status_code ({HTTP_STATUS_CODE}.ok)
	a_res.put_header_text (h.string)
	if not a_is_head then
	   a_res.put_string (l_msg)
	end

There's that `set_content_type` again. Finally, we will take a look at it:

    	set_content_type (a_h: HTTP_HEADER; a_media_variants: MEDIA_TYPE_VARIANT_RESULTS) is
			-- Set the content=type header in `a_h' according to `a_media_variants'.
		require
			a_h_not_void: a_h /= Void
		do
			if a_media_variants = Void or else not a_media_variants.is_acceptable then
				a_h.put_content_type ({HTTP_MIME_TYPES}.text_plain)
			else
				a_h.put_content_type (a_media_variants.media_type)
			end
			a_h.put_header_key_value ({HTTP_HEADER_NAMES}.header_vary, {HTTP_HEADER_NAMES}.header_accept)
		end

Firstly, if we haven't agreed a media-type, then we send our (negative) response as `plain/text`. Otherwise we will send the response in the agreed media-type. But in each case we add a `Vary:Accept` header. This tells proxy caches that they have to check the media-type before returning a cached result, as there may be a different representation available. Since we do not vary our representation by language, charset or encoding, we don't add `Vary:Accept-Language,Accept-Charset,Accept-Encoding`. But if we were to negotiate different representations on those dimensions also, we would need to list the appropriate headers in the `Vary` header.