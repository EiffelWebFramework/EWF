note
	description: "Summary description for {VARIANTS}. Utility class to support Server Side Content Negotiation "
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
	VARIANTS

inherit
	SHARED_CONNEG
	REFACTORING_HELPER
feature -- Media Type Negotiation

	media_type_preference ( mime_types_supported : LIST[STRING]; header : STRING) : STRING
			-- mime_types_supported represent media types supported by the server.
			-- header represent the Accept header, ie, the client preferences.
			-- Return which media type to use for representaion in a response, if the server support
			-- one media type, or empty in other case.
			-- Reference : http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
		do
			Result := mime.best_match (mime_types_supported, header)
		end


feature -- Encoding Negotiation

	charset_preference (server_charset_supported : LIST[STRING]; header: STRING) : STRING
			-- server_charset_supported represent a list of charset supported by the server.
			-- header represent the Accept-Charset header, ie, the client preferences.
			-- Return which Charset to use in a response, if the server support
			-- one Charset, or empty in other case.
			-- Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2
		do
			Result := common.best_match (server_charset_supported, header)
		end


feature -- Compression Negotiation

	encoding_preference (server_encoding_supported : LIST[STRING]; header: STRING) : STRING
			-- server_encoding_supported represent a list of encoding supported by the server.
			-- header represent the Accept-Encoding header, ie, the client preferences.
			-- Return which Encoding to use in a response, if the server support
			-- one Encoding, or empty in other case.
			-- Representation: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
		do
			Result := common.best_match (server_encoding_supported, header)
		end

feature -- Language Negotiation

	language_preference (server_language_supported : LIST[STRING]; header: STRING) : STRING
			-- server_language_supported represent a list of languages supported by the server.
			-- header represent the Accept-Language header, ie, the client preferences.
			-- Return which Language to use in a response, if the server support
			-- one Language, or empty in other case.
			-- Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
		do
			Result := language.best_match (server_language_supported, header)
		end

note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end


