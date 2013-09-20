note
	description: "Summary description for {CONNEG_SERVER_SIDE}. Utility class to support Server Side Content Negotiation "
	date: "$Date$"
	revision: "$Revision$"
	description: "[
		Reference : http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.1
		Server-driven Negotiation :	If the selection of the best representation for a response is made by an algorithm located at the server,
		it is called server-driven negotiation. Selection is based on the available representations of the response (the dimensions over which it can vary; e.g. language, content-coding, etc.)
		and the contents of particular header fields in the request message or on other information pertaining to the request (such as the network address of the client).
		Server-driven negotiation is advantageous when the algorithm for selecting from among the available representations is difficult to describe to the user agent,
		or when the server desires to send its "best guess" to the client along with the first response (hoping to avoid the round-trip delay of a subsequent request if the "best guess" is good enough for the user).
		In order to improve the server's guess, the user agent MAY include request header fields (Accept, Accept-Language, Accept-Encoding, etc.) which describe its preferences for such a response.
	]"
	EIS: "name=server driven negotiation", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.", "protocol=uri"

class
	CONNEG_SERVER_SIDE

inherit

	SHARED_CONNEG

	REFACTORING_HELPER

create
	make

feature -- Initialization

	make (a_mime: READABLE_STRING_8; a_language: READABLE_STRING_8; a_charset: READABLE_STRING_8; a_encoding: READABLE_STRING_8)
		do
			set_mime_default (a_mime)
			set_language_default (a_language)
			set_charset_default (a_charset)
			set_encoding_default (a_encoding)
		ensure
			mime_default_set: mime = a_mime
			language_default_set: language_default = a_language
			charset_default_set: charset_default = a_charset
			encoding_default_set: encoding_default = a_encoding
		end

feature -- AccessServer Side Defaults Formats

	mime_default: READABLE_STRING_8
			-- Media type which is acceptable for the response.

	language_default: READABLE_STRING_8
			-- Natural language that is preferred as a response to the request.

	charset_default: READABLE_STRING_8
			-- Character set that is  acceptable for the response.

	encoding_default: READABLE_STRING_8
			--  Content-coding  that is acceptable in the response.

feature -- Change Element

	set_mime_default (a_mime: READABLE_STRING_8)
			-- Set the mime_default with `a_mime'
		do
			mime_default := a_mime
		ensure
			mime_default_set: a_mime = mime_default
		end

	set_language_default (a_language: READABLE_STRING_8)
			-- Set the language_default with `a_language'
		do
			language_default := a_language
		ensure
			language_default_set: a_language = language_default
		end

	set_charset_default (a_charset: READABLE_STRING_8)
			-- Set the charset_default with `a_charset'
		do
			charset_default := a_charset
		ensure
			charset_default_set: a_charset = charset_default
		end

	set_encoding_default (a_encoding: READABLE_STRING_8)
		do
			encoding_default := a_encoding
		ensure
			encoding_default_set: a_encoding = encoding_default
		end



feature -- Media Type Negotiation

	media_type_preference (a_mime_types_supported: LIST [READABLE_STRING_8]; a_header: detachable READABLE_STRING_8): MEDIA_TYPE_VARIANT_RESULTS
			-- `a_mime_types_supported' represent media types supported by the server.
			-- `a_header represent' the Accept header, ie, the client preferences.
			-- Return which media type to use for representation in a response, if the server supports
			-- the requested media type, or empty in other case.
		note
			EIS: "name=media type", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1", "protocol=uri"
		local
			l_mime_match: READABLE_STRING_8
		do
			create Result
			if a_header = Void or else a_header.is_empty then
					-- the request has no Accept header, ie the header is empty, in this case we use the default format
				Result.set_acceptable (TRUE)
				Result.set_type (mime_default)
			else
					-- select the best match, server support, client preferences
				l_mime_match := mime.best_match (a_mime_types_supported, a_header)
				if l_mime_match.is_empty then
						-- The server does not support any of the media types preferred by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (a_mime_types_supported)
				else
						-- Set the best match
					Result.set_type (l_mime_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end
		end

feature -- Encoding Negotiation

	charset_preference (a_server_charset_supported: LIST [READABLE_STRING_8]; a_header: detachable READABLE_STRING_8): CHARACTER_ENCODING_VARIANT_RESULTS
			-- `a_server_charset_supported' represent a list of character sets supported by the server.
			-- `a_header' represents the Accept-Charset header, ie, the client preferences.
			-- Return which Charset to use in a response, if the server supports
			-- the requested Charset, or empty in other case.
		note
			EIS: "name=charset", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2", "protocol=uri"
		local
			l_charset_match: READABLE_STRING_8
		do
			create Result
			if a_header = Void or else a_header.is_empty then
					-- the request has no Accept-Charset header, ie the header is empty, in this case use default charset encoding
				Result.set_acceptable (TRUE)
				Result.set_type (charset_default)
			else
					-- select the best match, server support, client preferences
				l_charset_match := common.best_match (a_server_charset_supported, a_header)
				if l_charset_match.is_empty then
						-- The server does not support any of the compression types prefered by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (a_server_charset_supported)
				else
						-- Set the best match
					Result.set_type (l_charset_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end
		end

feature -- Compression Negotiation

	encoding_preference (a_server_encoding_supported: LIST [READABLE_STRING_8]; a_header: detachable READABLE_STRING_8): COMPRESSION_VARIANT_RESULTS
			-- `a_server_encoding_supported' represent a list of encoding supported by the server.
			-- `a_header' represent the Accept-Encoding header, ie, the client preferences.
			-- Return which Encoding to use in a response, if the server supports
			-- the requested Encoding, or empty in other case.
		note
			EIS: "name=encoding", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3", "protocol=uri"
		local
			l_compression_match: READABLE_STRING_8
		do
			create Result
			if a_header = Void or else a_header.is_empty then
					-- the request has no Accept-Encoding header, ie the header is empty, in this case do not compress representations
				Result.set_acceptable (TRUE)
				Result.set_type (encoding_default)
			else
					-- select the best match, server support, client preferences
				l_compression_match := common.best_match (a_server_encoding_supported, a_header)
				if l_compression_match.is_empty then
						-- The server does not support any of the compression types prefered by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (a_server_encoding_supported)
				else
						-- Set the best match
					Result.set_type (l_compression_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end
		end

feature -- Language Negotiation

	language_preference (a_server_language_supported: LIST [READABLE_STRING_8]; a_header: detachable READABLE_STRING_8): LANGUAGE_VARIANT_RESULTS
			-- `a_server_language_supported' represent a list of languages supported by the server.
			-- `a_header' represent the Accept-Language header, ie, the client preferences.
			-- Return which Language to use in a response, if the server supports
			-- the requested Language, or empty in other case.
		note
			EIS: "name=language", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4", "protocol=uri"

		local
			l_language_match: READABLE_STRING_8
		do
			create Result
			if a_header = Void or else a_header.is_empty then
					-- the request has no Accept header, ie the header is empty, in this case we use the default format
				Result.set_acceptable (TRUE)
				Result.set_type (language_default)
			else
					-- select the best match, server support, client preferences
				l_language_match := language.best_match (a_server_language_supported, a_header)
				if l_language_match.is_empty then
						-- The server does not support any of the media types prefered by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (a_server_language_supported)
				else
						-- Set the best match
					Result.set_type (l_language_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end
		end


note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
