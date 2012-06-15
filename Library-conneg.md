# Server-driven content negotiation

EWF supports server-driven content content negotiation, as defined in [HTTP/1.1 Content Negotiation](http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.1) . To enable this facility:

1. Add ${EWF}/library/network/protocol/conneg/conneg.ecf to your system ECF.
1. In the class where your handlers reside, add an attribute `conneg: CONNEG_SERVER_SIDE`, and ensure it is always attached (create in the creation procedure, or make it a once, or add an attribute body). An example creation call is: `create conneg.make ({HTTP_MIME_TYPES}.application_json, "en", "UTF-8", "")`. 

That call defines our defaults for media-type, language, charset and encoding, respectively. The encoding could also be written as `"identity"`. It means no compression. As an alternative, we might code `"gzip"`.

The user agent (a web browser, for example. or the curl program), can request different representations by using headers. For example, `Accept: application/json; q=0.2, application/xml` says the client would be very happy to get back an XML representation (if you omit the q for quality parameter, it defaults to 1, which is best), but (s)he will tolerate JSON. Clearly, we are going to be able to satisfy that client, as we serve JSON by default. But what if the client had requested `Accept: application/xml;q=0.8, text/html`? In this example, we are going to serve both JSON and XML representations upon request. A client who requests `Accept: text/html, text/plain` is going to be disappointed. For the other aspects (language, charset and encoding), we are not going to offer any choices. That does not mean we ignore the client's headers for these aspects. We are going to check if our representation is acceptable to the client, and if not, return a 406 Not Acceptable response (an alternative is to send our representation anyway, and let the user decide whether or not to use it).

Next, we need to declare all the representations we support:

`	mime_types_supported: LINKED_LIST [STRING] is
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



