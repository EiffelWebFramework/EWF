note
	description: "[
			Server request context of the httpd request
			
			It includes CGI interface and a few extra values that are usually valuable
			    meta_variable (a_name: READABLE_STRING_8): detachable WSF_STRING
			    meta_string_variable (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
			    
			In addition it provides
				
				query_parameter (a_name: READABLE_STRING_32): detachable WSF_VALUE
				form_parameter (a_name: READABLE_STRING_32): detachable WSF_VALUE
				cookie (a_name: READABLE_STRING_8): detachable WSF_VALUE
				...
				
			And also has
				execution_variable (a_name: READABLE_STRING_32): detachable ANY
					--| to keep value attached to the request
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_REQUEST

inherit
	DEBUG_OUTPUT

create {WSF_TO_WGI_SERVICE}
	make_from_wgi

convert
	make_from_wgi ({WGI_REQUEST})

feature {NONE} -- Initialization

	make_from_wgi (r: WGI_REQUEST)
		local
			tb: like meta_variables_table
		do
			wgi_request := r
			if attached r.meta_variables as l_vars then
				create tb.make (l_vars.count)
				across
					l_vars as c
				loop
					tb.force (new_string_value (c.key, c.item), c.key)
				end
			else
				create tb.make (0)
			end
			meta_variables_table := tb
			meta_variables := tb
			create error_handler.make
			create uploaded_files_table.make (0)
			set_raw_input_data_recorded (False)
			create {STRING_32} empty_string.make_empty

			create execution_variables_table.make (0)
			execution_variables_table.compare_objects

			initialize
			analyze
		end

	initialize
			-- Specific initialization
		local
			s8: detachable READABLE_STRING_8
		do
			init_mime_handlers

			--| Content-Length
			if attached content_length as s and then s.is_natural_64 then
				content_length_value := s.to_natural_64
			else
				content_length_value := 0
			end

			--| PATH_INFO
			path_info := url_encoder.decoded_string (wgi_request.path_info)

			--| PATH_TRANSLATED
			s8 := wgi_request.path_translated
			if s8 /= Void then
				path_translated := url_encoder.decoded_string (s8)
			end

				--| Here one can set its own environment entries if needed
			if meta_variable ({WSF_META_NAMES}.request_time) = Void then
				set_meta_string_variable ({WSF_META_NAMES}.request_time, date_time_utilities.unix_time_stamp (Void).out)
			end
		end

	wgi_request: WGI_REQUEST

feature -- Destroy

	destroy
			-- Destroy the object when request is completed
		do
				-- Removed uploaded files
			across
				-- Do not use `uploaded_files' directly
				-- just to avoid processing input data if not yet done
				uploaded_files_table as c
			loop
				delete_uploaded_file (c.item)
			end
		end

feature -- Status report

	debug_output: STRING_8
		do
			create Result.make_from_string (request_method + " " + request_uri)
		end

feature -- Setting

	raw_input_data_recorded: BOOLEAN assign set_raw_input_data_recorded
			-- Record RAW Input datas into `raw_input_data'
			-- otherwise just forget about it
			-- Default: False
			--| warning: you might keep in memory big amount of memory ...

feature -- Raw input data

	raw_input_data: detachable READABLE_STRING_8
			-- Raw input data is `raw_input_data_recorded' is True

	set_raw_input_data (d: READABLE_STRING_8)
		do
			raw_input_data := d
		end

feature -- Error handling

	has_error: BOOLEAN
		do
			Result := error_handler.has_error
		end

	error_handler: ERROR_HANDLER
			-- Error handler
			-- By default initialized to new handler	

feature -- Access: Input

	input: WGI_INPUT_STREAM
			-- Server input channel
		require
			is_not_chunked_input: not is_chunked_input
		do
			Result := wgi_request.input
		end

	is_chunked_input: BOOLEAN
			-- Is request using chunked transfer-encoding?	
		do
			Result := wgi_request.is_chunked_input
		end

	chunked_input: detachable WGI_CHUNKED_INPUT_STREAM
			-- Server input channel
		require
			is_chunked_input: is_chunked_input
		do
			Result := wgi_request.chunked_input
		end

feature -- Helper

	is_request_method (m: READABLE_STRING_8): BOOLEAN
			-- Is `m' the Current request_method?
		do
			Result := request_method.is_case_insensitive_equal (m)
		end

feature -- Eiffel WGI access

	wgi_version: READABLE_STRING_8
			-- Eiffel WGI version
			--| example: "1.0"
		do
			Result := wgi_request.wgi_version
		end

	wgi_implementation: READABLE_STRING_8
			-- Information about Eiffel WGI implementation
			--| example: "Eiffel Web Framework 1.0"
		do
			Result := wgi_request.wgi_implementation
		end

	wgi_connector: WGI_CONNECTOR
			-- Associated Eiffel WGI connector
		do
			Result := wgi_request.wgi_connector
		end

feature {NONE} -- Access: global variable

	items_table: HASH_TABLE [WSF_VALUE, READABLE_STRING_8]
			-- Table containing all the various variables
			-- Warning: this is computed each time, if you change the content of other containers
			-- this won't update this Result's content, unless you query it again
		do
			create Result.make (100)

			across
				meta_variables as vars
			loop
				Result.force (vars.item, vars.item.name)
			end

			across
				query_parameters as vars
			loop
				Result.force (vars.item, vars.item.name)
			end

			across
				form_parameters as vars
			loop
				Result.force (vars.item, vars.item.name)
			end

			across
				cookies as vars
			loop
				Result.force (vars.item, vars.item.name)
			end
		end

feature -- Access: global variable		

	items: ITERABLE [WSF_VALUE]
		do
			Result := items_table
		end

	item (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Variable named `a_name' from any of the variables container
			-- and following a specific order
			-- execution, environment, get, post, cookies
		do
			Result := meta_variable (a_name)
			if Result = Void then
				Result := query_parameter (a_name)
				if Result = Void then
					Result := form_parameter (a_name)
					if Result = Void then
						Result := cookie (a_name)
					end
				end
			end
		end

	string_item (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
		do
			if attached {WSF_STRING} item (a_name) as val then
				Result := val.string
			else
				check is_string_value: False end
			end
		end

feature -- Execution variables

	execution_variable (a_name: READABLE_STRING_8): detachable ANY
			-- Execution variable related to `a_name'
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			Result := execution_variables_table.item (a_name)
		end

	set_execution_variable (a_name: READABLE_STRING_32; a_value: detachable ANY)
		do
			execution_variables_table.force (a_value, a_name)
		ensure
			param_set: execution_variable (a_name) = a_value
		end

	unset_execution_variable (a_name: READABLE_STRING_32)
		do
			execution_variables_table.remove (a_name)
		ensure
			param_unset: execution_variable (a_name) = Void
		end

feature {NONE} -- Execution variables: implementation

	execution_variables_table: HASH_TABLE [detachable ANY, READABLE_STRING_32]

feature -- Access: CGI Meta variables

	meta_variable (a_name: READABLE_STRING_8): detachable WSF_STRING
			-- CGI Meta variable related to `a_name'
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			Result := meta_variables_table.item (a_name)
		end

	meta_string_variable (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
			-- CGI meta variable related to `a_name'
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			if attached meta_variable (a_name) as val then
				Result := val.string
			end
		end

	meta_variables: ITERABLE [WSF_STRING]
			-- CGI meta variables values

	meta_string_variable_or_default (a_name: READABLE_STRING_8; a_default: READABLE_STRING_32; use_default_when_empty: BOOLEAN): READABLE_STRING_32
			-- Value for meta parameter `a_name'
			-- If not found, return `a_default'
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			if attached meta_variable (a_name) as val then
				Result := val.string
				if use_default_when_empty and then Result.is_empty then
					Result := a_default
				end
			else
				Result := a_default
			end
		end

	set_meta_string_variable (a_name: READABLE_STRING_8; a_value: READABLE_STRING_32)
		do
			meta_variables_table.force (new_string_value (a_name, a_value), a_name)
		ensure
			param_set: attached {WSF_STRING} meta_variable (a_name) as val and then val.url_encoded_string.same_string (a_value)
		end

	unset_meta_variable (a_name: READABLE_STRING_8)
		do
			meta_variables_table.remove (a_name)
		ensure
			param_unset: meta_variable (a_name) = Void
		end

feature {NONE} -- Access: CGI meta parameters

	meta_variables_table: HASH_TABLE [WSF_STRING, READABLE_STRING_8]
			-- CGI Environment parameters		

feature -- Access: CGI meta parameters - 1.1			

	auth_type: detachable READABLE_STRING_8
			-- This variable is specific to requests made via the "http"
			-- scheme.
			--
			-- If the Script-URI required access authentication for external
			-- access, then the server MUST set the value of this variable
			-- from the 'auth-scheme' token in the wgi_request's "Authorization"
			-- header field. Otherwise it is set to NULL.
			--
			--  AUTH_TYPE   = "" | auth-scheme
			--  auth-scheme = "Basic" | "Digest" | token
			--
			-- HTTP access authentication schemes are described in section 11
			-- of the HTTP/1.1 specification [8]. The auth-scheme is not
			-- case-sensitive.
			--
			-- Servers MUST provide this metavariable to scripts if the
			-- wgi_request header included an "Authorization" field that was
			-- authenticated.
		do
			Result := wgi_request.auth_type
		end

	content_length: detachable READABLE_STRING_8
			-- This metavariable is set to the size of the message-body
			-- entity attached to the wgi_request, if any, in decimal number of
			-- octets. If no data are attached, then this metavariable is
			-- either NULL or not defined. The syntax is the same as for the
			-- HTTP "Content-Length" header field (section 14.14, HTTP/1.1
			-- specification [8]).
			--
			--  CONTENT_LENGTH = "" | 1*digit
			--
			-- Servers MUST provide this metavariable to scripts if the
			-- wgi_request was accompanied by a message-body entity.
		do
			Result := wgi_request.content_length
		end

	content_length_value: NATURAL_64
			-- Integer value related to `content_length"

	content_type: detachable READABLE_STRING_8
			-- If the wgi_request includes a message-body, CONTENT_TYPE is set to
			-- the Internet Media Type [9] of the attached entity if the type
			-- was provided via a "Content-type" field in the wgi_request header,
			-- or if the server can determine it in the absence of a supplied
			-- "Content-type" field. The syntax is the same as for the HTTP
			-- "Content-Type" header field.
			--
			--  CONTENT_TYPE = "" | media-type
			--  media-type   = type "/" subtype *( ";" parameter)
			--  type         = token
			--  subtype      = token
			--  parameter    = attribute "=" value
			--  attribute    = token
			--  value        = token | quoted-string
			--
			-- The type, subtype, and parameter attribute names are not
			-- case-sensitive. Parameter values MAY be case sensitive. Media
			-- types and their use in HTTP are described in section 3.7 of
			-- the HTTP/1.1 specification [8].
			--
			-- Example:
			--
			--  application/x-www-form-urlencoded
			--
			-- There is no default value for this variable. If and only if it
			-- is unset, then the script MAY attempt to determine the media
			-- type from the data received. If the type remains unknown, then
			-- the script MAY choose to either assume a content-type of
			-- application/octet-stream or reject the wgi_request with a 415
			-- ("Unsupported Media Type") error. See section 7.2.1.3 for more
			-- information about returning error status values.
			--
			-- Servers MUST provide this metavariable to scripts if a
			-- "Content-Type" field was present in the original wgi_request
			-- header. If the server receives a wgi_request with an attached
			-- entity but no "Content-Type" header field, it MAY attempt to
			-- determine the correct datatype, or it MAY omit this
			-- metavariable when communicating the wgi_request information to the
			-- script.
		do
			Result := wgi_request.content_type
		end

	gateway_interface: READABLE_STRING_8
			-- This metavariable is set to the dialect of CGI being used by
			-- the server to communicate with the script. Syntax:
			--
			--  GATEWAY_INTERFACE = "CGI" "/" major "." minor
			--  major             = 1*digit
			--  minor             = 1*digit
			--
			-- Note that the major and minor numbers are treated as separate
			-- integers and hence each may be more than a single digit. Thus
			-- CGI/2.4 is a lower version than CGI/2.13 which in turn is
			-- lower than CGI/12.3. Leading zeros in either the major or the
			-- minor number MUST be ignored by scripts and SHOULD NOT be
			-- generated by servers.
			--
			-- This document defines the 1.1 version of the CGI interface
			-- ("CGI/1.1").
			--
			-- Servers MUST provide this metavariable to scripts.
			--
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
		do
			Result := wgi_request.gateway_interface
		end

	path_info: READABLE_STRING_32
			-- The PATH_INFO metavariable specifies a path to be interpreted
			-- by the CGI script. It identifies the resource or sub-resource
			-- to be returned by the CGI script, and it is derived from the
			-- portion of the URI path following the script name but
			-- preceding any query data. The syntax and semantics are similar
			-- to a decoded HTTP URL 'path' token (defined in RFC 2396 [4]),
			-- with the exception that a PATH_INFO of "/" represents a single
			-- void path segment.
			--
			--  PATH_INFO = "" | ( "/" path )
			--  path      = segment *( "/" segment )
			--  segment   = *pchar
			--  pchar     = <any CHAR except "/">
			--
			-- The PATH_INFO string is the trailing part of the <path>
			-- component of the Script-URI (see section 3.2) that follows the
			-- SCRIPT_NAME portion of the path.
			--
			-- Servers MAY impose their own restrictions and limitations on
			-- what values they will accept for PATH_INFO, and MAY reject or
			-- edit any values they consider objectionable before passing
			-- them to the script.
			--
			-- Servers MUST make this URI component available to CGI scripts.
			-- The PATH_INFO value is case-sensitive, and the server MUST
			-- preserve the case of the PATH_INFO element of the URI when
			-- making it available to scripts.

	path_translated: detachable READABLE_STRING_32
			-- PATH_TRANSLATED is derived by taking any path-info component
			-- of the wgi_request URI (see section 6.1.6), decoding it (see
			-- section 3.1), parsing it as a URI in its own right, and
			-- performing any virtual-to-physical translation appropriate to
			-- map it onto the server's document repository structure. If the
			-- wgi_request URI includes no path-info component, the
			-- PATH_TRANSLATED metavariable SHOULD NOT be defined.
			--
			--
			--  PATH_TRANSLATED = *CHAR
			--
			-- For a wgi_request such as the following:
			--
			--  http://somehost.com/cgi-bin/somescript/this%2eis%2epath%2einfo
			--
			-- the PATH_INFO component would be decoded, and the result
			-- parsed as though it were a wgi_request for the following:
			--
			--  http://somehost.com/this.is.the.path.info
			--
			-- This would then be translated to a location in the server's
			-- document repository, perhaps a filesystem path something like
			-- this:
			--
			--  /usr/local/www/htdocs/this.is.the.path.info
			--
			-- The result of the translation is the value of PATH_TRANSLATED.
			--
			-- The value of PATH_TRANSLATED may or may not map to a valid
			-- repository location. Servers MUST preserve the case of the
			-- path-info segment if and only if the underlying repository
			-- supports case-sensitive names. If the repository is only
			-- case-aware, case-preserving, or case-blind with regard to
			-- document names, servers are not required to preserve the case
			-- of the original segment through the translation.
			--
			-- The translation algorithm the server uses to derive
			-- PATH_TRANSLATED is implementation defined; CGI scripts which
			-- use this variable may suffer limited portability.
			--
			-- Servers SHOULD provide this metavariable to scripts if and
			-- only if the wgi_request URI includes a path-info component.

	query_string: READABLE_STRING_8
			-- A URL-encoded string; the <query> part of the Script-URI. (See
			-- section 3.2.)
			--
			--  QUERY_STRING = query-string
			--  query-string = *uric

			-- The URL syntax for a query string is described in section 3 of
			-- RFC 2396 [4].
			--
			-- Servers MUST supply this value to scripts. The QUERY_STRING
			-- value is case-sensitive. If the Script-URI does not include a
			-- query component, the QUERY_STRING metavariable MUST be defined
			-- as an empty string ("").
		do
			Result := wgi_request.query_string
		end

	remote_addr: READABLE_STRING_8
			-- The IP address of the client sending the wgi_request to the
			-- server. This is not necessarily that of the user agent (such
			-- as if the wgi_request came through a proxy).
			--
			--  REMOTE_ADDR  = hostnumber
			--  hostnumber   = ipv4-address | ipv6-address

			-- The definitions of ipv4-address and ipv6-address are provided
			-- in Appendix B of RFC 2373 [13].
			--
			-- Servers MUST supply this value to scripts.
		do
			Result := wgi_request.remote_addr
		end

	remote_host: detachable READABLE_STRING_8
			-- The fully qualified domain name of the client sending the
			-- wgi_request to the server, if available, otherwise NULL. (See
			-- section 6.1.9.) Fully qualified domain names take the form as
			-- described in section 3.5 of RFC 1034 [10] and section 2.1 of
			-- RFC 1123 [5]. Domain names are not case sensitive.
			--
			-- Servers SHOULD provide this information to scripts.
		do
			Result := wgi_request.remote_host
		end

	remote_ident: detachable READABLE_STRING_8
			-- The identity information reported about the connection by a
			-- RFC 1413 [11] wgi_request to the remote agent, if available.
			-- Servers MAY choose not to support this feature, or not to
			-- wgi_request the data for efficiency reasons.
			--
			--  REMOTE_IDENT = *CHAR
			--
			-- The data returned may be used for authentication purposes, but
			-- the level of trust reposed in them should be minimal.
			--
			-- Servers MAY supply this information to scripts if the RFC1413
			-- [11] lookup is performed.
		do
			Result := wgi_request.remote_ident
		end

	remote_user: detachable READABLE_STRING_8
			-- If the wgi_request required authentication using the "Basic"
			-- mechanism (i.e., the AUTH_TYPE metavariable is set to
			-- "Basic"), then the value of the REMOTE_USER metavariable is
			-- set to the user-ID supplied. In all other cases the value of
			-- this metavariable is undefined.
			--
			--  REMOTE_USER = *OCTET
			--
			-- This variable is specific to requests made via the HTTP
			-- protocol.
			--
			-- Servers SHOULD provide this metavariable to scripts.
		do
			Result := wgi_request.remote_user
		end

	request_method: READABLE_STRING_8
			-- The REQUEST_METHOD metavariable is set to the method with
			-- which the wgi_request was made, as described in section 5.1.1 of
			-- the HTTP/1.0 specification [3] and section 5.1.1 of the
			-- HTTP/1.1 specification [8].
			--
			--  REQUEST_METHOD   = http-method
			--  http-method      = "GET" | "HEAD" | "POST" | "PUT" | "DELETE"
			--                     | "OPTIONS" | "TRACE" | extension-method
			--  extension-method = token
			--
			-- The method is case sensitive. CGI/1.1 servers MAY choose to
			-- process some methods directly rather than passing them to
			-- scripts.
			--
			-- This variable is specific to requests made with HTTP.
			--
			-- Servers MUST provide this metavariable to scripts.
		do
			Result := wgi_request.request_method
		end

	script_name: READABLE_STRING_8
			-- The SCRIPT_NAME metavariable is set to a URL path that could
			-- identify the CGI script (rather than the script's output). The
			-- syntax and semantics are identical to a decoded HTTP URL
			-- 'path' token (see RFC 2396 [4]).
			--
			--  SCRIPT_NAME = "" | ( "/" [ path ] )
			--
			-- The SCRIPT_NAME string is some leading part of the <path>
			-- component of the Script-URI derived in some implementation
			-- defined manner. No PATH_INFO or QUERY_STRING segments (see
			-- sections 6.1.6 and 6.1.8) are included in the SCRIPT_NAME
			-- value.
			--
			-- Servers MUST provide this metavariable to scripts.
		do
			Result := wgi_request.script_name
		end

	server_name: READABLE_STRING_8
			-- The SERVER_NAME metavariable is set to the name of the server,
			-- as derived from the <host> part of the Script-URI (see section
			-- 3.2).
			--
			--  SERVER_NAME = hostname | hostnumber
			--
			-- Servers MUST provide this metavariable to scripts.
		do
			Result := wgi_request.server_name
		end

	server_port: INTEGER
			-- The SERVER_PORT metavariable is set to the port on which the
			-- wgi_request was received, as used in the <port> part of the
			-- Script-URI.
			--
			--  SERVER_PORT = 1*digit
			--
			-- If the <port> portion of the script-URI is blank, the actual
			-- port number upon which the wgi_request was received MUST be
			-- supplied.
			--
			-- Servers MUST provide this metavariable to scripts.
		do
			Result := wgi_request.server_port
		end

	server_protocol: READABLE_STRING_8
			-- The SERVER_PROTOCOL metavariable is set to the name and
			-- revision of the information protocol with which the wgi_request
			-- arrived. This is not necessarily the same as the protocol
			-- version used by the server in its response to the client.
			--
			--  SERVER_PROTOCOL   = HTTP-Version | extension-version
			--                      | extension-token
			--  HTTP-Version      = "HTTP" "/" 1*digit "." 1*digit
			--  extension-version = protocol "/" 1*digit "." 1*digit
			--  protocol          = 1*( alpha | digit | "+" | "-" | "." )
			--  extension-token   = token
			--
			-- 'protocol' is a version of the <scheme> part of the
			-- Script-URI, but is not identical to it. For example, the
			-- scheme of a wgi_request may be "https" while the protocol remains
			-- "http". The protocol is not case sensitive, but by convention,
			-- 'protocol' is in upper case.
			--
			-- A well-known extension token value is "INCLUDED", which
			-- signals that the current document is being included as part of
			-- a composite document, rather than being the direct target of
			-- the client wgi_request.
			--
			-- Servers MUST provide this metavariable to scripts.
		do
			Result := wgi_request.server_protocol
		end

	server_software: READABLE_STRING_8
			-- The SERVER_SOFTWARE metavariable is set to the name and
			-- version of the information server software answering the
			-- wgi_request (and running the gateway).
			--
			--  SERVER_SOFTWARE = 1*product
			--  product         = token [ "/" product-version ]
			--  product-version = token

			-- Servers MUST provide this metavariable to scripts.
		do
			Result := wgi_request.server_software
		end

feature -- HTTP_*

	http_accept: detachable READABLE_STRING_8
			-- Contents of the Accept: header from the current wgi_request, if there is one.
			-- Example: 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
		do
			Result := wgi_request.http_accept
		end

	http_accept_charset: detachable READABLE_STRING_8
			-- Contents of the Accept-Charset: header from the current wgi_request, if there is one.
			-- Example: 'iso-8859-1,*,utf-8'.
		do
			Result := wgi_request.http_accept_charset
		end

	http_accept_encoding: detachable READABLE_STRING_8
			-- Contents of the Accept-Encoding: header from the current wgi_request, if there is one.
			-- Example: 'gzip'.
		do
			Result := wgi_request.http_accept_encoding
		end

	http_accept_language: detachable READABLE_STRING_8
			-- Contents of the Accept-Language: header from the current wgi_request, if there is one.
			-- Example: 'en'.
		do
			Result := wgi_request.http_accept_language
		end

	http_connection: detachable READABLE_STRING_8
			-- Contents of the Connection: header from the current wgi_request, if there is one.
			-- Example: 'Keep-Alive'.
		do
			Result := wgi_request.http_connection
		end

	http_host: detachable READABLE_STRING_8
			-- Contents of the Host: header from the current wgi_request, if there is one.
		do
			Result := wgi_request.http_host
		end

	http_referer: detachable READABLE_STRING_8
			-- The address of the page (if any) which referred the user agent to the current page.
			-- This is set by the user agent.
			-- Not all user agents will set this, and some provide the ability to modify HTTP_REFERER as a feature.
			-- In short, it cannot really be trusted.
		do
			Result := wgi_request.http_referer
		end

	http_user_agent: detachable READABLE_STRING_8
			-- Contents of the User-Agent: header from the current wgi_request, if there is one.
			-- This is a string denoting the user agent being which is accessing the page.
			-- A typical example is: Mozilla/4.5 [en] (X11; U; Linux 2.2.9 i586).
			-- Among other things, you can use this value to tailor your page's
			-- output to the capabilities of the user agent.
		do
			Result := wgi_request.http_user_agent
		end

	http_authorization: detachable READABLE_STRING_8
			-- Contents of the Authorization: header from the current wgi_request, if there is one.
		do
			Result := wgi_request.http_authorization
		end

	http_transfer_encoding: detachable READABLE_STRING_8
			-- Transfer-Encoding
			-- for instance chunked
		do
			Result := wgi_request.http_transfer_encoding
		end

feature -- Extra CGI environment variables

	request_uri: READABLE_STRING_8
			-- The URI which was given in order to access this page; for instance, '/index.html'.
		do
			Result := wgi_request.request_uri
		end

	orig_path_info: detachable READABLE_STRING_8
			-- Original version of `path_info' before processed by Current environment
		do
			Result := wgi_request.orig_path_info
		end

	request_time: detachable DATE_TIME
			-- Request time (UTC)
		do
			if
				attached {WSF_STRING} meta_variable ({WSF_META_NAMES}.request_time) as t and then
				t.string.is_integer_64
			then
				Result := date_time_utilities.unix_time_stamp_to_date_time (t.string.to_integer_64)
			end
		end

feature -- Cookies

	cookies: ITERABLE [WSF_VALUE]
		do
			Result := cookies_table
		end

	cookie (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Field for name `a_name'.
		do
			Result := cookies_table.item (a_name)
		end

feature {NONE} -- Cookies

	cookies_table: HASH_TABLE [WSF_VALUE, READABLE_STRING_32]
			-- Expanded cookies variable
		local
			i,j,p,n: INTEGER
			l_cookies: like internal_cookies_table
			k,v,s: STRING
		do
			l_cookies := internal_cookies_table
			if l_cookies = Void then
				if attached {WSF_STRING} meta_variable ({WSF_META_NAMES}.http_cookie) as val then
					s := val.string
					create l_cookies.make (5)
					l_cookies.compare_objects
					from
						n := s.count
						p := 1
						i := 1
					until
						p < 1
					loop
						i := s.index_of ('=', p)
						if i > 0 then
							j := s.index_of (';', i)
							if j = 0 then
								j := n + 1
								k := s.substring (p, i - 1)
								v := s.substring (i + 1, n)

								p := 0 -- force termination
							else
								k := s.substring (p, i - 1)
								v := s.substring (i + 1, j - 1)
								p := j + 1
							end
							k.left_adjust
							k.right_adjust
							add_value_to_table (k, v, l_cookies)
						end
					end
				else
					create l_cookies.make (0)
					l_cookies.compare_objects
				end
				internal_cookies_table := l_cookies
			end
			Result := l_cookies
		end

feature -- Query parameters

	query_parameters: ITERABLE [WSF_VALUE]
		do
			Result := query_parameters_table
		end

	query_parameter (a_name: READABLE_STRING_32): detachable WSF_VALUE
			-- Parameter for name `n'.
		do
			Result := query_parameters_table.item (a_name)
		end

feature {NONE} -- Query parameters: implementation

	query_parameters_table: HASH_TABLE [WSF_VALUE, READABLE_STRING_32]
			-- Variables extracted from QUERY_STRING	
		local
			vars: like internal_query_parameters_table
			p,e: INTEGER
			rq_uri: like request_uri
			s: detachable STRING
		do
			vars := internal_query_parameters_table
			if vars = Void then
				s := query_string
				if s = Void then
					rq_uri := request_uri
					p := rq_uri.index_of ('?', 1)
					if p > 0 then
						e := rq_uri.index_of ('#', p + 1)
						if e = 0 then
							e := rq_uri.count
						else
							e := e - 1
						end
						s := rq_uri.substring (p+1, e)
					end
				end
				vars := urlencoded_parameters (s)
				vars.compare_objects
				internal_query_parameters_table := vars
			end
			Result := vars
		end

	urlencoded_parameters (a_content: detachable READABLE_STRING_8): HASH_TABLE [WSF_VALUE, READABLE_STRING_32]
			-- Import `a_content'
		local
			n, p, i, j: INTEGER
			s: READABLE_STRING_8
			l_name, l_value: READABLE_STRING_8
		do
			if a_content = Void then
				create Result.make (0)
			else
				n := a_content.count
				if n = 0 then
					create Result.make (0)
				else
					create Result.make (3)
					from
						p := 1
					until
						p = 0
					loop
						i := a_content.index_of ('&', p)
						if i = 0 then
							s := a_content.substring (p, n)
							p := 0
						else
							s := a_content.substring (p, i - 1)
							p := i + 1
						end
						if not s.is_empty then
							j := s.index_of ('=', 1)
							if j > 0 then
								l_name := s.substring (1, j - 1)
								l_value := s.substring (j + 1, s.count)
								add_value_to_table (l_name, l_value, Result)
							end
						end
					end
				end
			end
		end

	add_value_to_table (a_name: READABLE_STRING_8; a_value: READABLE_STRING_8; a_table: HASH_TABLE [WSF_VALUE, READABLE_STRING_32])
		local

			v: detachable WSF_VALUE
			n,k,r: STRING_8
			k32: STRING_32
			p,q: INTEGER
			tb,ptb: detachable WSF_TABLE
		do
			--| Check if this is a list format such as   choice[]  or choice[a] or even choice[a][] or choice[a][b][c]...
			p := a_name.index_of ('[', 1)
			if p > 0 then
				q := a_name.index_of (']', p + 1)
				if q > p then
					n := a_name.substring (1, p - 1)
					r := a_name.substring (q + 1, a_name.count)
					r.left_adjust; r.right_adjust

					create tb.make (n)
					if a_table.has_key (tb.name) and then attached {WSF_TABLE} a_table.found_item as l_existing_table then
						tb := l_existing_table
					end

					k := a_name.substring (p + 1, q - 1)
					k.left_adjust; k.right_adjust
					if k.is_empty then
						k.append_integer (tb.count + 1)
					end
					v := tb
					n.append_character ('[')
					n.append (k)
					n.append_character (']')

					from
					until
						r.is_empty
					loop
						ptb := tb
						p := r.index_of ({CHARACTER_8} '[', 1)
						if p > 0 then
							q := r.index_of ({CHARACTER_8} ']', p + 1)
							if q > p then
								k32 := url_encoder.decoded_string (k)
								if attached {WSF_TABLE} ptb.value (k32) as l_tb_value then
									tb := l_tb_value
								else
									create tb.make (n)
									ptb.add_value (tb, k32)
								end

								k := r.substring (p + 1, q - 1)
								r := r.substring (q + 1, r.count)
								r.left_adjust; r.right_adjust
								if k.is_empty then
									k.append_integer (tb.count + 1)
								end
								n.append_character ('[')
								n.append (k)
								n.append_character (']')
							end
						else
							r.wipe_out
							--| Ignore bad value
						end
					end
					tb.add_value (new_string_value (n, a_value), k)
				else
					--| Missing end bracket
				end
			end
			if v = Void then
				v := new_string_value (a_name, a_value)
			end
			if a_table.has_key (v.name) and then attached a_table.found_item as l_existing_value then
				if tb /= Void then
					--| Already done in previous part
				elseif attached {WSF_MULTIPLE_STRING} l_existing_value as l_multi then
					l_multi.add_value (v)
				else
					a_table.force (create {WSF_MULTIPLE_STRING}.make_with_array (<<l_existing_value, v>>), v.name)
					check replaced: a_table.found and then a_table.found_item ~ l_existing_value end
				end
			else
				a_table.force (v, v.name)
			end
		end

feature -- Form fields and related

	form_parameters: ITERABLE [WSF_VALUE]
		do
			Result := form_parameters_table
		end

	form_parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Field for name `a_name'.
		do
			Result := form_parameters_table.item (a_name)
		end

	has_uploaded_file: BOOLEAN
			-- Has any uploaded file?
		do
				-- Be sure, the `form_parameters' are already processed
			get_form_parameters

			Result := not uploaded_files_table.is_empty
		end

	uploaded_files: ITERABLE [WSF_UPLOADED_FILE]
			-- uploaded files values
			--| filename: original path from the user
			--| type: content type
			--| tmp_name: path to temp file that resides on server
			--| tmp_base_name: basename of `tmp_name'
			--| error: if /= 0 , there was an error : TODO ...
			--| size: size of the file given by the http request
		do
				-- Be sure, the `form_parameters' are already processed
			get_form_parameters

				-- return uploaded files table
			Result := uploaded_files_table
		end

feature -- Access: MIME handler

	has_mime_handler (a_content_type: READABLE_STRING_8): BOOLEAN
			-- Has a MIME handler registered for `a_content_type'?
		do
			if attached mime_handlers as hdls then
				from
					hdls.start
				until
					hdls.after or Result
				loop
					Result := hdls.item_for_iteration.valid_content_type (a_content_type)
					hdls.forth
				end
			end
		end

	register_mime_handler (a_handler: WSF_MIME_HANDLER)
			-- Register `a_handler' for `a_content_type'
		local
			hdls: like mime_handlers
		do
			hdls := mime_handlers
			if hdls = Void then
				create hdls.make (3)
				hdls.compare_objects
				mime_handlers := hdls
			end
			hdls.force (a_handler)
		end

	mime_handler (a_content_type: READABLE_STRING_8): detachable WSF_MIME_HANDLER
			-- Mime handler associated with `a_content_type'
		do
			if attached mime_handlers as hdls then
				from
					hdls.start
				until
					hdls.after or Result /= Void
				loop
					Result := hdls.item_for_iteration
					if not Result.valid_content_type (a_content_type) then
						Result := Void
					end
					hdls.forth
				end
			end
		ensure
			has_mime_handler_implies_attached: has_mime_handler (a_content_type) implies Result /= Void
		end

feature {NONE} -- Implementation: MIME handler

	init_mime_handlers
		do
			register_mime_handler (create {WSF_MULTIPART_FORM_DATA_HANDLER}.make (error_handler))
			register_mime_handler (create {WSF_APPLICATION_X_WWW_FORM_URLENCODED_HANDLER})
		end

	mime_handlers: detachable ARRAYED_LIST [WSF_MIME_HANDLER]
			-- Table of mime handles

feature {NONE} -- Form fields and related

	uploaded_files_table: HASH_TABLE [WSF_UPLOADED_FILE, READABLE_STRING_32]

	get_form_parameters
			-- Variables sent by POST, ... request	
		local
			vars: like internal_form_data_parameters_table
			l_raw_data_cell: detachable CELL [detachable STRING_8]
			l_type: like content_type
		do
			vars := internal_form_data_parameters_table
			if vars = Void then
				if not is_chunked_input and content_length_value = 0 then
					create vars.make (0)
					vars.compare_objects
				else
					if raw_input_data_recorded then
						create l_raw_data_cell.put (Void)
					end
					create vars.make (5)
					vars.compare_objects

					l_type := content_type
					if l_type /= Void and then attached mime_handler (l_type) as hdl then
						hdl.handle (l_type, Current, vars, l_raw_data_cell)
					end
					if l_raw_data_cell /= Void and then attached l_raw_data_cell.item as l_raw_data then
						-- What if no mime handler is associated to `l_type' ?
						set_raw_input_data (l_raw_data)
					end
				end
				internal_form_data_parameters_table := vars
			end
		ensure
			internal_form_data_parameters_table /= Void
		end

	form_parameters_table: HASH_TABLE [WSF_VALUE, READABLE_STRING_32]
			-- Variables sent by POST request	
		local
			vars: like internal_form_data_parameters_table
		do
			get_form_parameters
			vars := internal_form_data_parameters_table
			if vars = Void then
				check form_parameters_already_retrieved: False end
				create vars.make (0)
			end
			Result := vars
		end

feature -- Uploaded File Handling

	is_uploaded_file (a_filename: STRING): BOOLEAN
			-- Is `a_filename' a file uploaded via HTTP Form
		local
			l_files: like uploaded_files_table
		do
			l_files := uploaded_files_table
			if not l_files.is_empty then
				from
					l_files.start
				until
					l_files.after or Result
				loop
					if attached l_files.item_for_iteration.tmp_name as l_tmp_name and then l_tmp_name.same_string (a_filename) then
						Result := True
					end
					l_files.forth
				end
			end
		end

feature -- URL Utility

	absolute_script_url (a_path: STRING): STRING
			-- Absolute Url for the script if any, extended by `a_path'
		do
			Result := script_url (a_path)
			if attached http_host as h then
				Result.prepend (h)
				Result.prepend ("http://")
			else
				--| Issue ??
			end
		end

	script_url (a_path: STRING): STRING
			-- Url relative to script name if any, extended by `a_path'
		local
			l_base_url: like internal_url_base
			i,m,n,spos: INTEGER
			l_rq_uri: like request_uri
		do
			l_base_url := internal_url_base
			if l_base_url = Void then
				if attached script_name as l_script_name then
					l_rq_uri := request_uri
					if l_rq_uri.starts_with (l_script_name) then
						l_base_url := l_script_name
					else
						--| Handle Rewrite url engine, to have clean path
						from
							i := 1
							m := l_rq_uri.count
							n := l_script_name.count
						until
							i > m or i > n or l_rq_uri[i] /= l_script_name[i]
						loop
							if l_rq_uri[i] = '/' then
								spos := i
							end
							i := i + 1
						end
						if i > 1 then
							if l_rq_uri[i-1] = '/' then
								i := i -1
							elseif spos > 0 then
								i := spos
							end
							spos := l_rq_uri.substring_index (path_info, i)
							if spos > 0 then
								l_base_url := l_rq_uri.substring (1, spos - 1)
							else
								l_base_url := l_rq_uri.substring (1, i - 1)
							end
						end
					end
				end
				if l_base_url = Void then
					create l_base_url.make_empty
				end
				internal_url_base := l_base_url
			end
			create Result.make_from_string (l_base_url)
			Result.append (a_path)
		end

feature {NONE} -- Implementation: URL Utility

	internal_url_base: detachable STRING
			-- URL base of potential script	

feature -- Element change

	set_raw_input_data_recorded (b: BOOLEAN)
			-- Set `raw_input_data_recorded' to `b'
		do
			raw_input_data_recorded := b
		end

	set_error_handler (ehdl: like error_handler)
			-- Set `error_handler' to `ehdl'
		do
			error_handler := ehdl
		end

feature {WSF_MIME_HANDLER} -- Temporary File handling		

	delete_uploaded_file (uf: WSF_UPLOADED_FILE)
			-- Delete file `a_filename'
		require
			uf_valid: uf /= Void
		local
			f: RAW_FILE
		do
			if uploaded_files_table.has_item (uf) then
				if attached uf.tmp_name as fn then
					create f.make (fn)
					if f.exists and then f.is_writable then
						f.delete
					else
						error_handler.add_custom_error (0, "Can not delete uploaded file", "Can not delete file %""+ fn +"%"")
					end
				else
					error_handler.add_custom_error (0, "Can not delete uploaded file", "Can not delete uploaded file %""+ uf.name +"%" Tmp File not found")
				end
			else
				error_handler.add_custom_error (0, "Not an uploaded file", "This file %""+ uf.name +"%" is not an uploaded file.")
			end
		end

	save_uploaded_file (a_up_file: WSF_UPLOADED_FILE; a_content: STRING)
			-- Save uploaded file content to `a_filename'
		local
			bn: STRING
			l_safe_name: STRING
			f: RAW_FILE
			dn: STRING
			fn: FILE_NAME
			d: DIRECTORY
			n: INTEGER
			rescued: BOOLEAN
		do
			if not rescued then
				-- FIXME: should it be configured somewhere?
				dn := (create {EXECUTION_ENVIRONMENT}).current_working_directory
				create d.make (dn)
				if d.exists and then d.is_writable then
					l_safe_name := a_up_file.safe_filename
					from
						create fn.make_from_string (dn)
						bn := "tmp-" + l_safe_name
						fn.set_file_name (bn)
						create f.make (fn.string)
						n := 0
					until
						not f.exists
						or else n > 1_000
					loop
						n := n + 1
						fn.make_from_string (dn)
						bn := "tmp-" + n.out + "-" + l_safe_name
						fn.set_file_name (bn)
						f.make (fn.string)
					end

					if not f.exists or else f.is_writable then
						a_up_file.set_tmp_name (f.name)
						a_up_file.set_tmp_basename (bn)
						f.open_write
						f.put_string (a_content)
						f.close
					else
						a_up_file.set_error (-1)
					end
				else
					error_handler.add_custom_error (0, "Directory not writable", "Can not create file in directory %""+ dn +"%"")
				end
				uploaded_files_table.force (a_up_file, a_up_file.name)
			else
				a_up_file.set_error (-1)
			end
		rescue
			rescued := True
			retry
		end

feature {WSF_MIME_HANDLER} -- Input data access

	form_input_data (nb: NATURAL_64): READABLE_STRING_8
			-- All data from input form
		local
			nb32: INTEGER
			n64: NATURAL_64
			n: INTEGER
			t: STRING
			s: STRING_8
		do
			from
				n64 := nb
				nb32 := n64.to_integer_32
				create s.make (nb32)
				Result := s
				n := nb32
				if n > 1_024 then
					n := 1_024
				end
			until
				n64 <= 0
			loop
				input.read_string (n)
				t := input.last_string
				s.append_string (t)
				if t.count < n then
					n64 := 0
				else
					n64 := n64 - t.count.as_natural_64
				end
			end
		end

feature {NONE} -- Internal value

	internal_query_parameters_table: detachable like query_parameters_table
			-- cached value for `query_parameters'

	internal_form_data_parameters_table: detachable like form_parameters_table
			-- cached value for `form_fields'

	internal_cookies_table: detachable like cookies_table
			-- cached value for `cookies'

feature {NONE} -- Implementation

	report_bad_request_error (a_message: detachable STRING)
			-- Report error
		local
			e: WSF_ERROR
		do
			create e.make ({HTTP_STATUS_CODE}.bad_request)
			if a_message /= Void then
				e.set_message (a_message)
			end
			error_handler.add_error (e)
		end

	analyze
			-- Extract relevant meta parameters
		local
			s: detachable READABLE_STRING_8
		do
			s := request_uri
			if s.is_empty then
				report_bad_request_error ("Missing URI")
			end
			if not has_error then
				s := request_method
				if s.is_empty then
					report_bad_request_error ("Missing request method")
				end
			end
			if not has_error then
				s := http_host
				if s = Void or else s.is_empty then
					report_bad_request_error ("Missing host header")
				end
			end
		end

feature {NONE} -- Implementation: utilities	

	single_slash_starting_string (s: READABLE_STRING_32): STRING_32
			-- Return the string `s' (or twin) with one and only one starting slash
		local
			i, n: INTEGER
		do
			n := s.count
			if n > 1 then
				if s[1] /= '/' then
					create Result.make (1 + n)
					Result.append_character ('/')
					Result.append (s)
				elseif s[2] = '/' then
					--| We need to remove all starting slash, except one
					from
						i := 3
					until
						i > n
					loop
						if s[i] /= '/' then
							n := 0 --| exit loop
						else
							i := i + 1
						end
					end
					n := s.count
					check i >= 2 and i <= n end
					Result := s.substring (i - 1, s.count)
				else
					--| starts with one '/' and only one		
					Result := s
				end
			elseif n = 1 then
				if s[1] = '/' then
					Result := s
				else
					create Result.make (2)
					Result.append_character ('/')
					Result.append (s)
				end
			else --| n = 0
				create Result.make_filled ('/', 1)
			end
		ensure
			one_starting_slash: Result[1] = '/' and (Result.count = 1 or else Result[2] /= '/')
		end

	new_string_value (a_name: READABLE_STRING_8; a_value: READABLE_STRING_8): WSF_STRING
		do
			create Result.make (a_name, a_value)
		end

	empty_string: READABLE_STRING_32
			-- Reusable empty string

	url_encoder: URL_ENCODER
		once
			create {UTF8_URL_ENCODER} Result
		end

	date_time_utilities: HTTP_DATE_TIME_UTILITIES
			-- Utilities classes related to date and time.
		once
			create Result
		end

invariant
	empty_string_unchanged: empty_string.is_empty


note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
