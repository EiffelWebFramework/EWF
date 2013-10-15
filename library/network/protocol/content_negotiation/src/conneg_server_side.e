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
	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_mediatype_dft: READABLE_STRING_8; a_language_dft: READABLE_STRING_8; a_charset_dft: READABLE_STRING_8; a_encoding_dft: READABLE_STRING_8)
			-- Initialize Current with default Media type, language, charset and encoding.
		do
			initialize
			set_default_media_type (a_mediatype_dft)
			set_default_language (a_language_dft)
			set_default_charset (a_charset_dft)
			set_default_encoding (a_encoding_dft)
		ensure
			default_media_type_set: default_media_type = a_mediatype_dft
			default_language_set: default_language = a_language_dft
			default_charset_set: default_charset = a_charset_dft
			default_encoding_set: default_encoding = a_encoding_dft
		end

	initialize
			-- Initialize Current
		do
			create accept_media_type_parser
			create any_header_parser
			create accept_language_parser
		end

	accept_media_type_parser: HTTP_ACCEPT_MEDIA_TYPE_PARSER
			-- MIME

	any_header_parser: HTTP_ANY_ACCEPT_HEADER_PARSER
			-- Charset and Encoding

	accept_language_parser: HTTP_ACCEPT_LANGUAGE_PARSER
			-- Language	

feature -- Access: Server Side Defaults Formats

	default_media_type: READABLE_STRING_8
			-- Media type which is acceptable for the response.

	default_language: READABLE_STRING_8
			-- Natural language that is preferred as a response to the request.

	default_charset: READABLE_STRING_8
			-- Character set that is  acceptable for the response.

	default_encoding: READABLE_STRING_8
			--  Content-coding  that is acceptable in the response.

feature -- Change Element

	set_default_media_type (a_mediatype: READABLE_STRING_8)
			-- Set `default_media_type' with `a_mediatype'
		do
			default_media_type := a_mediatype
		ensure
			default_media_type_set: a_mediatype = default_media_type
		end

	set_default_language (a_language: READABLE_STRING_8)
			-- Set `default_language' with `a_language'
		do
			default_language := a_language
		ensure
			default_language_set: a_language = default_language
		end

	set_default_charset (a_charset: READABLE_STRING_8)
			-- Set `default_charset' with `a_charset'
		do
			default_charset := a_charset
		ensure
			default_charset_set: a_charset = default_charset
		end

	set_default_encoding (a_encoding: READABLE_STRING_8)
			-- Set `default_encoding' with `a_encoding'	
		do
			default_encoding := a_encoding
		ensure
			default_encoding_set: a_encoding = default_encoding
		end

feature -- Media Type Negotiation

	media_type_preference (a_mime_types_supported: LIST [READABLE_STRING_8]; a_header: detachable READABLE_STRING_8): HTTP_ACCEPT_MEDIA_TYPE_VARIANTS
			-- `a_mime_types_supported' represent media types supported by the server.
			-- `a_header represent' the Accept header, ie, the client preferences.
			-- Return which media type to use for representation in a response, if the server supports
			-- the requested media type, or empty in other case.
		note
			EIS: "name=media type", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1", "protocol=uri"
		local
			l_mime_match: READABLE_STRING_8
		do
			create Result.make
			Result.set_supported_variants (a_mime_types_supported)
			if a_header = Void or else a_header.is_empty then
					-- the request has no Accept header, ie the header is empty, in this case we use the default format
				Result.set_acceptable (True)
				Result.set_variant_value (default_media_type)
			else
				Result.set_vary_header_value

					-- select the best match, server support, client preferences
				l_mime_match := accept_media_type_parser.best_match (a_mime_types_supported, a_header)
				if l_mime_match.is_empty then
						-- The server does not support any of the media types preferred by the client
					Result.set_acceptable (False)
				else
						-- Set the best match
					Result.set_variant_value (l_mime_match)
					Result.set_acceptable (True)
				end
			end
		end

feature -- Encoding Negotiation

	charset_preference (a_server_charset_supported: LIST [READABLE_STRING_8]; a_header: detachable READABLE_STRING_8): HTTP_ACCEPT_CHARSET_VARIANTS
			-- `a_server_charset_supported' represent a list of character sets supported by the server.
			-- `a_header' represents the Accept-Charset header, ie, the client preferences.
			-- Return which Charset to use in a response, if the server supports
			-- the requested Charset, or empty in other case.
		note
			EIS: "name=charset", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2", "protocol=uri"
		local
			l_charset_match: READABLE_STRING_8
		do
			create Result.make
			Result.set_supported_variants (a_server_charset_supported)
			if a_header = Void or else a_header.is_empty then
					-- the request has no Accept-Charset header, ie the header is empty, in this case use default charset encoding
				Result.set_acceptable (True)
				Result.set_variant_value (default_charset)
			else
				Result.set_vary_header_value

					-- select the best match, server support, client preferences
				l_charset_match := any_header_parser.best_match (a_server_charset_supported, a_header)
				if l_charset_match.is_empty then
						-- The server does not support any of the compression types prefered by the client
					Result.set_acceptable (False)
				else
						-- Set the best match
					Result.set_variant_value (l_charset_match)
					Result.set_acceptable (True)
				end
			end
		end

feature -- Compression Negotiation

	encoding_preference (a_server_encoding_supported: LIST [READABLE_STRING_8]; a_header_value: detachable READABLE_STRING_8): HTTP_ACCEPT_ENCODING_VARIANTS
			-- `a_server_encoding_supported' represent a list of encoding supported by the server.
			-- `a_header_value' represent the Accept-Encoding header, ie, the client preferences.
			-- Return which Encoding to use in a response, if the server supports
			-- the requested Encoding, or empty in other case.
		note
			EIS: "name=encoding", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3", "protocol=uri"
		local
			l_compression_match: READABLE_STRING_8
		do
			create Result.make
			Result.set_supported_variants (a_server_encoding_supported)
			if a_header_value = Void or else a_header_value.is_empty then
					-- the request has no Accept-Encoding header, ie the header is empty, in this case do not compress representations
				Result.set_acceptable (True)
				Result.set_variant_value (default_encoding)
			else
				Result.set_vary_header_value

					-- select the best match, server support, client preferences
				l_compression_match := any_header_parser.best_match (a_server_encoding_supported, a_header_value)
				if l_compression_match.is_empty then
						-- The server does not support any of the compression types prefered by the client
					Result.set_acceptable (False)
				else
						-- Set the best match
					Result.set_variant_value (l_compression_match)
					Result.set_acceptable (True)
				end
			end
		end

feature -- Language Negotiation

	language_preference (a_server_language_supported: LIST [READABLE_STRING_8]; a_header_value: detachable READABLE_STRING_8): HTTP_ACCEPT_LANGUAGE_VARIANTS
			-- `a_server_language_supported' represent a list of languages supported by the server.
			-- `a_header_value' represent the Accept-Language header, ie, the client preferences.
			-- Return which Language to use in a response, if the server supports
			-- the requested Language, or empty in other case.
		note
			EIS: "name=language", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4", "protocol=uri"

		local
			l_language_match: READABLE_STRING_8
		do
			create Result.make
			Result.set_supported_variants (a_server_language_supported)

			if a_header_value = Void or else a_header_value.is_empty then
					-- the request has no Accept header, ie the header is empty, in this case we use the default format
				Result.set_acceptable (True)
				Result.set_variant_value (default_language)
			else
				Result.set_vary_header_value

					-- select the best match, server support, client preferences
				l_language_match := accept_language_parser.best_match (a_server_language_supported, a_header_value)
				if l_language_match.is_empty then
						-- The server does not support any of the media types prefered by the client
					Result.set_acceptable (False)
				else
						-- Set the best match
					Result.set_variant_value (l_language_match)
					Result.set_acceptable (True)
				end
			end
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
