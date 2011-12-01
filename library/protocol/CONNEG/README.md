CONNEG is a library that provides utilities to select the best repesentation of a resource for a client
where there are multiple representations available.

Using this labrary you can retrieve the best Variant for media type, language preference, enconding and compression.
The library is based on eMIME Eiffel MIME library based on Joe Gregorio code

Take into account that the library is under development so is expected that the API chanherge.

The library contains utilities that deal with content negotiation (server driven negotiation).This utility class
is based on ideas taken from the Book Restful WebServices Cookbook

The class CONNEG_SERVER_SIDE contains several features that helps to write different type of negotiations (media type, language,
charset and compression).
So for each of the following questions, you will have a corresponding method to help in the solution.

How to implement Media type negotiation?
Hint: Use CONNEG_SERVER_SIDE.media_type_preference

How to implement Language Negotiation?
Hint: Use CONNEG_SERVER_SIDE.language_preference


How to implement Character encoding Negotiation?
Hint: Use CONNEG_SERVER_SIDE.charset_preference

How to implement Compression Negotiation?
Hint: Use CONNEG_SERVER_SIDE.encoding_preference

There is also a test case where you can check how to use this class.

note
	description: "Summary description for CONNEG_SERVER_SIDE. Utility class to support Server Side Content Negotiation "
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

class interface
	CONNEG_SERVER_SIDE

create 
	make

feature -- Initialization

	make (a_mime: STRING_8; a_language: STRING_8; a_charset: STRING_8; an_encoding: STRING_8)
	
feature -- Compression Negotiation

	encoding_preference (server_encoding_supported: LIST [STRING_8]; header: STRING_8): COMPRESSION_VARIANT_RESULTS
			-- server_encoding_supported represent a list of encoding supported by the server.
			-- header represent the Accept-Encoding header, ie, the client preferences.
			-- Return which Encoding to use in a response, if the server support
			-- one Encoding, or empty in other case.
			-- Representation: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
	
feature -- Encoding Negotiation

	charset_preference (server_charset_supported: LIST [STRING_8]; header: STRING_8): CHARACTER_ENCODING_VARIANT_RESULTS
			-- server_charset_supported represent a list of charset supported by the server.
			-- header represent the Accept-Charset header, ie, the client preferences.
			-- Return which Charset to use in a response, if the server support
			-- one Charset, or empty in other case.
			-- Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2
	
feature -- Language Negotiation

	language_preference (server_language_supported: LIST [STRING_8]; header: STRING_8): LANGUAGE_VARIANT_RESULTS
			-- server_language_supported represent a list of languages supported by the server.
			-- header represent the Accept-Language header, ie, the client preferences.
			-- Return which Language to use in a response, if the server support
			-- one Language, or empty in other case.
			-- Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
	
feature -- Media Type Negotiation

	media_type_preference (mime_types_supported: LIST [STRING_8]; header: STRING_8): MEDIA_TYPE_VARIANT_RESULTS
			-- mime_types_supported represent media types supported by the server.
			-- header represent the Accept header, ie, the client preferences.
			-- Return which media type to use for representaion in a response, if the server support
			-- one media type, or empty in other case.
			-- Reference : http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	
feature -- Server Side Defaults Formats

	charset_default: STRING_8

	encoding_default: STRING_8

	language_default: STRING_8

	mime_default: STRING_8

	set_charset_default (a_charset: STRING_8)
			-- set the charset_default with `a_charset'
		ensure
			set_charset: a_charset ~ charset_default

	set_encoding_defautl (an_encoding: STRING_8)
		ensure
			set_encoding: an_encoding ~ encoding_default

	set_language_default (a_language: STRING_8)
			-- set the language_default with `a_language'
		ensure
			set_language: a_language ~ language_default

	set_mime_default (a_mime: STRING_8)
			-- set the mime_default with `a_mime'
		ensure
			set_mime_default: a_mime ~ mime_default
	
note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end -- class CONNEG_SERVER_SIDE

