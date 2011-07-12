note
	description: "Summary description for {GW_ENVIRONMENT_VARIABLES}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_ENVIRONMENT_VARIABLES

inherit
	GW_ENVIRONMENT
		redefine
			update_path_info
		end

create
	make_with_variables

feature {NONE} -- Initialization

	make_with_variables (a_vars: HASH_TABLE [STRING, STRING])
			-- Fill with variable from `a_vars'
		local
			s: detachable STRING
		do
			create empty_string.make_empty

			create table.make (a_vars.count)
			from
				a_vars.start
			until
				a_vars.after
			loop
				table.force (a_vars.item_for_iteration, a_vars.key_for_iteration)
				a_vars.forth
			end

				--| QUERY_STRING
			query_string := variable_or_default ({GW_ENVIRONMENT_NAMES}.query_string, empty_string, False)

				--| REQUEST_METHOD
			request_method := variable_or_default ({GW_ENVIRONMENT_NAMES}.request_method, empty_string, False)

				--| CONTENT_TYPE
			s := variable ({GW_ENVIRONMENT_NAMES}.content_type)
			if s /= Void and then not s.is_empty then
				content_type := s
			else
				content_type := Void
			end

				--| CONTENT_LENGTH
			s := variable ({GW_ENVIRONMENT_NAMES}.content_length)
			content_length := s
			if s /= Void and then s.is_integer then
				content_length_value := s.to_integer
			else
				--| content_length := 0
			end

				--| PATH_INFO
			path_info := variable_or_default ({GW_ENVIRONMENT_NAMES}.path_info, empty_string, False)

				--| SERVER_NAME
			server_name := variable_or_default ({GW_ENVIRONMENT_NAMES}.server_name, empty_string, False)

				--| SERVER_PORT
			s := variable ({GW_ENVIRONMENT_NAMES}.server_port)
			if s /= Void and then s.is_integer then
				server_port := s.to_integer
			else
				server_port := 80
			end

				--| SCRIPT_NAME
			script_name := variable_or_default ({GW_ENVIRONMENT_NAMES}.script_name, empty_string, False)

				--| REMOTE_ADDR
			remote_addr := variable_or_default ({GW_ENVIRONMENT_NAMES}.remote_addr, empty_string, False)

				--| REMOTE_HOST
			remote_host := variable_or_default ({GW_ENVIRONMENT_NAMES}.remote_host, empty_string, False)

				--| REQUEST_URI
			request_uri := variable_or_default ({GW_ENVIRONMENT_NAMES}.request_uri, empty_string, False)
		end

feature -- Access

	table: HASH_TABLE [STRING, STRING]

feature -- Access

	variable (a_name: STRING): detachable STRING
		do
			Result := table.item (a_name)
		end

	has_variable (a_name: STRING): BOOLEAN
		do
			Result := table.has_key (a_name)
		end

feature {GW_REQUEST_CONTEXT, GW_APPLICATION, GW_CONNECTOR} -- Element change

	set_variable (a_name: STRING; a_value: STRING)
		do
			table.force (a_value, a_name)
		end

	unset_variable (a_name: STRING)
		do
			table.remove (a_name)
		end

feature -- Common Gateway Interface - 1.1       8 January 1996

	auth_type: detachable STRING

	content_length: detachable STRING

	content_length_value: INTEGER

	content_type: detachable STRING

	gateway_interface: STRING
		do
			Result := variable_or_default ({GW_ENVIRONMENT_NAMES}.gateway_interface, "", False)
		end

	path_info: STRING
			-- <Precursor/>
			--
			--| For instance, if the current script was accessed via the URL
			--| http://www.example.com/eiffel/path_info.exe/some/stuff?foo=bar, then $_SERVER['PATH_INFO'] would contain /some/stuff.
			--|
			--| Note that is the PATH_INFO variable does not exists, the `path_info' value will be empty

	path_translated: detachable STRING
		do
			Result := variable ({GW_ENVIRONMENT_NAMES}.path_translated)
		end

	query_string: STRING

	remote_addr: STRING

	remote_host: STRING

	remote_ident: detachable STRING
		do
			Result := variable ({GW_ENVIRONMENT_NAMES}.remote_ident)
		end

	remote_user: detachable STRING
		do
			Result := variable ({GW_ENVIRONMENT_NAMES}.remote_user)
		end

	request_method: STRING

	script_name: STRING

	server_name: STRING

	server_port: INTEGER

	server_protocol: STRING
		do
			Result := variable_or_default ({GW_ENVIRONMENT_NAMES}.server_protocol, "HTTP/1.0", True)
		end

	server_software: STRING
		do
			Result := variable_or_default ({GW_ENVIRONMENT_NAMES}.server_software, "Unknown Server", True)
		end

feature -- HTTP_*

	http_accept: detachable STRING
			-- Contents of the Accept: header from the current request, if there is one.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_accept)
		end

	http_accept_charset: detachable STRING
			-- Contents of the Accept-Charset: header from the current request, if there is one.
			-- Example: 'iso-8859-1,*,utf-8'.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_accept_charset)
		end

	http_accept_encoding: detachable STRING
			-- Contents of the Accept-Encoding: header from the current request, if there is one.
			-- Example: 'gzip'.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_accept_encoding)
		end

	http_accept_language: detachable STRING
			-- Contents of the Accept-Language: header from the current request, if there is one.
			-- Example: 'en'.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_accept_language)
		end

	http_connection: detachable STRING
			-- Contents of the Connection: header from the current request, if there is one.
			-- Example: 'Keep-Alive'.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_connection)
		end

	http_host: detachable STRING
			-- Contents of the Host: header from the current request, if there is one.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_host)
		end

	http_referer: detachable STRING
			-- The address of the page (if any) which referred the user agent to the current page.
			-- This is set by the user agent.
			-- Not all user agents will set this, and some provide the ability to modify HTTP_REFERER as a feature.
			-- In short, it cannot really be trusted.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_referer)
		end

	http_user_agent: detachable STRING
			-- Contents of the User-Agent: header from the current request, if there is one.
			-- This is a string denoting the user agent being which is accessing the page.
			-- A typical example is: Mozilla/4.5 [en] (X11; U; Linux 2.2.9 i586).
			-- Among other things, you can use this value to tailor your page's
			-- output to the capabilities of the user agent.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_user_agent)
		end

	http_authorization: detachable STRING
			-- Contents of the Authorization: header from the current request, if there is one.
		do
			Result := table.item ({GW_ENVIRONMENT_NAMES}.http_authorization)
		end

feature -- Extra

	request_uri: STRING
			-- The URI which was given in order to access this page; for instance, '/index.html'.

	orig_path_info: detachable STRING
			-- Original version of `path_info' before processed by Current environment

feature {GW_REQUEST_CONTEXT} -- Update

	set_orig_path_info (s: STRING)
		do
			orig_path_info := s
			set_variable ({GW_ENVIRONMENT_NAMES}.orig_path_info, s)
		end

	unset_orig_path_info
		do
			orig_path_info := Void
			unset_variable ({GW_ENVIRONMENT_NAMES}.orig_path_info)
		end

	update_path_info (a_path_info: like path_info)
		do
			path_info := a_path_info
			set_variable ({GW_ENVIRONMENT_NAMES}.path_info, a_path_info)
		end

feature {NONE} -- Implementation

	empty_string: STRING
			-- Reusable empty string

invariant
	empty_string_unchanged: empty_string.is_empty

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
