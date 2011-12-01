note
	description: "Summary description for {CONNEG_SERVER_SIDE}. Utility class to support Server Side Content Negotiation "
	author: ""
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
class
	CONNEG_SERVER_SIDE

inherit
	SHARED_CONNEG
	REFACTORING_HELPER
create
	make

feature -- Initialization
	make ( a_mime: STRING; a_language : STRING; a_charset :STRING; an_encoding: STRING)
		do
			set_mime_default (a_mime)
			set_language_default (a_language)
			set_charset_default (a_charset)
			set_encoding_defautl (an_encoding)
		end
feature -- Server Side Defaults Formats
	mime_default :  STRING

	set_mime_default ( a_mime: STRING)
		-- set the mime_default with `a_mime'
		do
			mime_default := a_mime
		ensure
			set_mime_default: a_mime ~ mime_default
		end


	language_default : STRING

	set_language_default (a_language : STRING)
			-- set the language_default with `a_language'
		do
			language_default := a_language
		ensure
			set_language : a_language ~ language_default
		end


	charset_default : STRING

	set_charset_default (a_charset : STRING)
			-- set the charset_default with `a_charset'
		do
			charset_default := a_charset
		ensure
			set_charset : a_charset ~ charset_default
		end


	encoding_default : STRING

	set_encoding_defautl (an_encoding : STRING)
		do
			encoding_default := an_encoding
		ensure
			set_encoding : an_encoding ~ encoding_default
		end



feature -- Media Type Negotiation

	media_type_preference ( mime_types_supported : LIST[STRING]; header : STRING) : MEDIA_TYPE_VARIANT_RESULTS
			-- mime_types_supported represent media types supported by the server.
			-- header represent the Accept header, ie, the client preferences.
			-- Return which media type to use for representaion in a response, if the server support
			-- one media type, or empty in other case.
			-- Reference : http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
		local
			mime_match: STRING
		do
			create Result
			if header.is_empty then
				-- the request has no Accept header, ie the header is empty, in this case we use the default format
				Result.set_acceptable (TRUE)
				Result.set_media_type (mime_default)
			else
		        -- select the best match, server support, client preferences	
				mime_match := mime.best_match (mime_types_supported, header)
				if mime_match.is_empty then
					-- The server does not support any of the media types prefered by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (mime_types_supported)
				else
					-- Set the best match
					Result.set_media_type(mime_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end
		end


feature -- Encoding Negotiation

	charset_preference (server_charset_supported : LIST[STRING]; header: STRING) : CHARACTER_ENCODING_VARIANT_RESULTS
			-- server_charset_supported represent a list of charset supported by the server.
			-- header represent the Accept-Charset header, ie, the client preferences.
			-- Return which Charset to use in a response, if the server support
			-- one Charset, or empty in other case.
			-- Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2
		local
			charset_match : STRING
		do
			create Result
			if header.is_empty then
				-- the request has no Accept-Charset header, ie the header is empty, in this case use default charset encoding
				-- (UTF-8)
				Result.set_acceptable (TRUE)
				Result.set_character_type (charset_default)
			else
		        -- select the best match, server support, client preferences	
				charset_match := common.best_match (server_charset_supported, header)
				if charset_match.is_empty then
					-- The server does not support any of the compression types prefered by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (server_charset_supported)
				else
					-- Set the best match
					Result.set_character_type(charset_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end
		end

feature -- Compression Negotiation

	encoding_preference (server_encoding_supported : LIST[STRING]; header: STRING) : COMPRESSION_VARIANT_RESULTS
			-- server_encoding_supported represent a list of encoding supported by the server.
			-- header represent the Accept-Encoding header, ie, the client preferences.
			-- Return which Encoding to use in a response, if the server support
			-- one Encoding, or empty in other case.
			-- Representation: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
		local
			compression_match : STRING
		do
			create Result
			if header.is_empty then
				-- the request has no Accept-Encoding header, ie the header is empty, in this case do not compress representations
				Result.set_acceptable (TRUE)
				Result.set_compression_type (encoding_default)
			else
		        -- select the best match, server support, client preferences	
				compression_match := common.best_match (server_encoding_supported, header)
				if compression_match.is_empty then
					-- The server does not support any of the compression types prefered by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (server_encoding_supported)
				else
					-- Set the best match
					Result.set_compression_type(compression_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end

		end


feature -- Language Negotiation

	language_preference (server_language_supported : LIST[STRING]; header: STRING) : LANGUAGE_VARIANT_RESULTS
			-- server_language_supported represent a list of languages supported by the server.
			-- header represent the Accept-Language header, ie, the client preferences.
			-- Return which Language to use in a response, if the server support
			-- one Language, or empty in other case.
			-- Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
		local
			language_match: STRING
		do
			create Result
			if header.is_empty then
				-- the request has no Accept header, ie the header is empty, in this case we use the default format
				Result.set_acceptable (TRUE)
				Result.set_language_type (language_default)
			else
		        -- select the best match, server support, client preferences	
				language_match := language.best_match (server_language_supported, header)
				if language_match.is_empty then
					-- The server does not support any of the media types prefered by the client
					Result.set_acceptable (False)
					Result.set_supported_variants (server_language_supported)
				else
					-- Set the best match
					Result.set_language_type(language_match)
					Result.set_acceptable (True)
					Result.set_variant_header
				end
			end
		end

feature -- Apache Conneg Algorithm

note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end


