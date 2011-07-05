note
	description: "[
	
		Interface for a request environment
		It includes CGI interface and a few extra values that are usually valuable


		--   A `Script URI' can be defined; this describes the resource identified
		--   by the environment variables. Often, this URI will be the same as the
		--   URI requested by the client (the `Client URI'); however, it need not
		--   be. Instead, it could be a URI invented by the server, and so it can
		--   only be used in the context of the server and its CGI interface.
		--
		--   The script URI has the syntax of generic-RL as defined in section 2.1
		--   of RFC 1808 [7], with the exception that object parameters and
		--   fragment identifiers are not permitted:
		--
		--      <scheme>://<host>:<port>/<path>?<query>
		--
		--   The various components of the script URI are defined by some of the
		--   environment variables (see below);
		--
		--      script-uri = protocol "://" SERVER_NAME ":" SERVER_PORT enc-script
		--                   enc-path-info "?" QUERY_STRING
		--
		--   where `protocol' is found from SERVER_PROTOCOL, `enc-script' is a
		--   URL-encoded version of SCRIPT_NAME and `enc-path-info' is a
		--   URL-encoded version of PATH_INFO.	

	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred
class
	GW_ENVIRONMENT

inherit
	GW_VARIABLES [STRING_8]
--		undefine
--			copy, is_equal
--		end

	ITERABLE [STRING_8]

--	HASH_TABLE [STRING, STRING]
--		undefine
--			empty_duplicate --| Hwo come I need that??? CHECK BUG
--		end

feature -- Access

	table: HASH_TABLE [STRING, STRING]
			-- These variables are specific to requests made with HTTP.
			-- Interpretation of these variables may depend on the value of
			-- SERVER_PROTOCOL.
			--
			-- Environment variables with names beginning with "HTTP_" contain
			-- header data read from the client, if the protocol used was HTTP.
			-- The HTTP header name is converted to upper case, has all
			-- occurrences of "-" replaced with "_" and has "HTTP_" prepended to
			-- give the environment variable name. The header data may be
			-- presented as sent by the client, or may be rewritten in ways which
			-- do not change its semantics. If multiple headers with the same
			-- field-name are received then they must be rewritten as a single
			-- header having the same semantics. Similarly, a header that is
			-- received on more than one line must be merged onto a single line.
			-- The server must, if necessary, change the representation of the
			-- data (for example, the character set) to be appropriate for a CGI
			-- environment variable.
			--
			-- The server is not required to create environment variables for all
			-- the headers that it receives. In particular, it may remove any
			-- headers carrying authentication information, such as
			-- "Authorization"; it may remove headers whose value is available to
			-- the script via other variables, such as "Content-Length" and
			-- "Content-Type".
		deferred
		end

feature -- Access: table

	new_cursor: HASH_TABLE_ITERATION_CURSOR [STRING_8, STRING_8]
			-- Fresh cursor associated with current structure
		do
			create Result.make (table)
		end

feature -- Common Gateway Interface - 1.1       8 January 1996

	auth_type: detachable STRING
			-- The variable is specific to requests made with HTTP.
			-- If the script URI would require access authentication for external
			-- access, then this variable is found from the `auth-scheme' token
			-- in the request, otherwise NULL.
			--    auth-scheme = "Basic" | token
			-- HTTP access authentication schemes are described in section 11 of s
			-- the HTTP/1.0 specification [3]. The auth-scheme is not
			-- case-sensitive.
		deferred
		end

	content_length: INTEGER
			-- The size of the entity attached to the request, if any, in decimal
			-- number of octets. If no data is attached, then NULL. The syntax is
			-- the same as the HTTP Content-Length header (section 10, HTTP/1.0
			-- specification [3]).
			--
			-- CONTENT_LENGTH = "" | [ 1*digit ]
		deferred
		end

	content_type: STRING
			-- The Internet Media Type [9] of the attached entity. The syntax is
			-- the same as the HTTP Content-Type header.
			--
			--  CONTENT_TYPE = "" | media-type
			--  media-type   = type "/" subtype *( ";" parameter)
			--  type         = token
			--  subtype      = token
			--  parameter    = attribute "=" value
			--  attribute    = token
			--  value        = token | quoted-string
			--
			-- The type, subtype and parameter attribute names are not
			-- case-sensitive. Parameter values may be case sensitive.  Media
			-- types and their use in HTTP are described section 3.6 of the
			-- HTTP/1.0 specification [3]. Example:
			--
			--  application/x-www-form-urlencoded
			--
			-- There is no default value for this variable. If and only if it is
			-- unset, then the script may attempt to determine the media type
			-- from the data received. If the type remains unknown, then
			-- application/octet-stream should be assumed.
		deferred
		end

	gateway_interface: STRING
			-- The version of the CGI specification to which this server
			-- complies.  Syntax:
			--
			--  GATEWAY_INTERFACE =  "CGI" "/" 1*digit "." 1*digit
			--
			-- Note that the major and minor numbers are treated as separate
			-- integers and that each may be incremented higher than a single
			-- digit.  Thus CGI/2.4 is a lower version than CGI/2.13 which in
			-- turn is lower than CGI/12.3. Leading zeros must be ignored by
			-- scripts and should never be generated by servers.
		deferred
		end

	path_info: STRING
			-- A path to be interpreted by the CGI script. It identifies the
			-- resource or sub-resource to be returned by the CGI script. The
			-- syntax and semantics are similar to a decoded HTTP URL `hpath'
			-- token (defined in RFC 1738 [4]), with the exception that a
			-- PATH_INFO of "/" represents a single void path segment. Otherwise,
			-- the leading "/" character is not part of the path.
			--    PATH_INFO = "" | "/" path
			--    path      = segment *( "/" segment )
			--    segment   = *pchar
			--    pchar     = <any CHAR except "/">
			-- The PATH_INFO string is the trailing part of the <path> component
			-- of the script URI that follows the SCRIPT_NAME part of the path.
			--
			--| For instance, if the current script was accessed via the URL
			--| http://www.example.com/eiffel/path_info.exe/some/stuff?foo=bar, then $_SERVER['PATH_INFO'] would contain /some/stuff.
			--|
			--| Note that is the PATH_INFO variable does not exists, the `path_info' value will be empty
		deferred
		end

	path_translated: STRING
			-- The OS path to the file that the server would attempt to access
			-- were the client to request the absolute URL containing the path
			-- PATH_INFO.  i.e for a request of

			--    protocol "://" SERVER_NAME ":" SERVER_PORT enc-path-info

			-- where `enc-path-info' is a URL-encoded version of PATH_INFO. If
			-- PATH_INFO is NULL then PATH_TRANSLATED is set to NULL.

			--    PATH_TRANSLATED = *CHAR

			-- PATH_TRANSLATED need not be supported by the server. The server
			-- may choose to set PATH_TRANSLATED to NULL for reasons of security,
			-- or because the path would not be interpretable by a CGI script;
			-- such as the object it represented was internal to the server and
			-- not visible in the file-system; or for any other reason.

			-- The algorithm the server uses to derive PATH_TRANSLATED is
			-- obviously implementation defined; CGI scripts which use this
			-- variable may suffer limited portability.
		deferred
		end

	query_string: STRING
			-- A URL-encoded search string; the <query> part of the script URI.

			--    QUERY_STRING = query-string
			--    query-string = *qchar
			--    qchar        = unreserved | escape | reserved
			--    unreserved   = alpha | digit | safe | extra
			--    reserved     = ";" | "/" | "?" | ":" | "@" | "&" | "="
			--    safe         = "$" | "-" | "_" | "." | "+"
			--    extra        = "!" | "*" | "'" | "(" | ")" | ","
			--    escape       = "%" hex hex
			--    hex          = digit | "A" | "B" | "C" | "D" | "E" | "F" | "a"
			--                 | "b" | "c" | "d" | "e" | "f"

			-- The URL syntax for a search string is described in RFC 1738 [4].
		deferred
		end

	remote_addr: STRING
			-- The IP address of the agent sending the request to the server. Not
			-- necessarily that of the client.

			--    REMOTE_ADDR = hostnumber
			--    hostnumber  = digits "." digits "." digits "." digits
			--    digits      = 1*digit
		deferred
		end

	remote_host: STRING
			-- The fully qualified domain name of the agent sending the request
			-- to the server, if available, otherwise NULL. Not necessarily that
			-- of the client. Fully qualified domain names take the form as
			-- described in section 3.5 of RFC 1034 [8] and section 2.1 of RFC
			-- 1123 [5]; a sequence of domain labels separated by ".", each
			-- domain label starting and ending with an alphanumerical character
			-- and possibly also containing "-" characters. The rightmost domain
			-- label will never start with a digit. Domain names are not case
			-- sensitive.

			--    REMOTE_HOST   = "" | hostname
			--    hostname      = *( domainlabel ".") toplabel
			--    domainlabel   = alphadigit [ *alphahypdigit alphadigit ]
			--    toplabel      = alpha [ *alphahypdigit alphadigit ]
			--    alphahypdigit = alphadigit | "-"
			--    alphadigit    = alpha | digit
		deferred
		end

	remote_ident: detachable STRING
			-- The identity information reported about the connection by a RFC
			-- 931 [10] request to the remote agent, if available. The server may
			-- choose not to support this feature, or not to request the data for
			-- efficiency reasons.

			--    REMOTE_IDENT = *CHAR

			-- The data returned is not appropriate for use as authentication
			-- information.
		deferred
		end

	remote_user: detachable STRING
			-- This variable is specific to requests made with HTTP.

			-- If AUTH_TYPE is "Basic", then the user-ID sent by the client. If
			-- AUTH_TYPE is NULL, then NULL, otherwise undefined.

			--    userid      = token
		deferred
		end

	request_method: STRING
			-- This variable is specific to requests made with HTTP.

			-- The method with which the request was made, as described in
			-- section 5.1.1 of the HTTP/1.0 specification [3].

			--    http-method      = "GET" | "HEAD" | "POST" | extension-method
			--    extension-method = token

			-- The method is case sensitive.
		deferred
		end

	script_name: STRING
			-- A URL path that could identify the CGI script (rather then the
			-- particular CGI output). The syntax and semantics are identical to
			-- a decoded HTTP URL `hpath' token [4].

			--    SCRIPT_NAME = "" | "/" [ path ]

			-- The leading "/" is not part of the path. It is optional if the
			-- path is NULL.

			-- The SCRIPT_NAME string is some leading part of the <path>
			-- component of the script URI derived in some implementation defined
			-- manner.
		deferred
		end

	server_name: STRING
			-- The name for this server, as used in the <host> part of the script
			-- URI. Thus either a fully qualified domain name, or an IP address.

			--    SERVER_NAME = hostname | hostnumber
		deferred
		end

	server_port: INTEGER
			-- The port on which this request was received, as used in the <port>
			-- part of the script URI.

			--    SERVER_PORT = 1*digit
		deferred
		end

	server_protocol: STRING
			-- The name and revision of the information protocol this request
			-- came in with.

			--    SERVER_PROTOCOL   = HTTP-Version | extension-version
			--    HTTP-Version      = "HTTP" "/" 1*digit "." 1*digit
			--    extension-version = protocol "/" 1*digit "." 1*digit
			--    protocol          = 1*( alpha | digit | "+" | "-" | "." )

			-- `protocol' is a version of the <scheme> part of the script URI,
			-- and is not case sensitive. By convention, `protocol' is in upper
			-- case.
		deferred
		end

	server_software: STRING
			-- The name and version of the information server software answering
			-- the request (and running the gateway).

			--    SERVER_SOFTWARE = *CHAR
		deferred
		end

feature -- HTTP_*

	http_accept_charset: detachable STRING
			-- Contents of the Accept-Charset: header from the current request, if there is one.
			-- Example: 'iso-8859-1,*,utf-8'.
		deferred
		end

	http_accept_encoding: detachable STRING
			-- Contents of the Accept-Encoding: header from the current request, if there is one.
			-- Example: 'gzip'.
		deferred
		end

	http_accept_language: detachable STRING
			-- Contents of the Accept-Language: header from the current request, if there is one.
			-- Example: 'en'.
		deferred
		end

	http_connection: detachable STRING
			-- Contents of the Connection: header from the current request, if there is one.
			-- Example: 'Keep-Alive'.
		deferred
		end

	http_host: detachable STRING
			-- Contents of the Host: header from the current request, if there is one.
		deferred
		end

	http_referer: detachable STRING
			-- The address of the page (if any) which referred the user agent to the current page.
			-- This is set by the user agent.
			-- Not all user agents will set this, and some provide the ability to modify HTTP_REFERER as a feature.
			-- In short, it cannot really be trusted.
		deferred
		end

	http_user_agent: detachable STRING
			-- Contents of the User-Agent: header from the current request, if there is one.
			-- This is a string denoting the user agent being which is accessing the page.
			-- A typical example is: Mozilla/4.5 [en] (X11; U; Linux 2.2.9 i586).
			-- Among other things, you can use this value to tailor your page's
			-- output to the capabilities of the user agent.
		deferred
		end

	http_authorization: detachable STRING
			-- Contents of the Authorization: header from the current request, if there is one.
		deferred
		end

feature -- Extra

	request_uri: STRING
			-- The URI which was given in order to access this page; for instance, '/index.html'.
		deferred
		end

	orig_path_info: detachable STRING
			-- Original version of `path_info' before processed by Current environment
		deferred
		end

;note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
