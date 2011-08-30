note
	description: "Summary description for {REQUEST_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_HANDLER

feature {NONE} -- Initialization

	initialize
			-- Initialize various attributes
		do
		end

feature -- Access

	description: detachable STRING
			-- Optional descriptiong

feature -- Status report

	is_valid_context (req: WGI_REQUEST): BOOLEAN
			-- Is `req' valid context for current handler?
		do
			Result := request_method_name_supported (req.request_method)
		end

feature -- Execution

	execute (a_hdl_context: REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute request handler	
		require
			is_valid_context: is_valid_context (req)
		local
			rescued: BOOLEAN
		do
			if not rescued then
				if request_method_name_supported (req.request_method) then
					pre_execute (req)
					execute_application (a_hdl_context, req, res)
					post_execute (req, res)
				else
					execute_method_not_allowed (a_hdl_context, req, res)
				end
			else
				rescue_execute (req, res)
			end
		rescue
			rescued := True
			retry
		end

	execute_method_not_allowed (a_hdl_context: REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			s: STRING
			lst: LIST [STRING]
		do
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			create s.make (25)
			from
				lst := supported_request_method_names
				lst.start
			until
				lst.after
			loop
				s.append_string (lst.item)
				if not lst.islast then
					s.append_character (',')
					s.append_character (' ')
				end
				lst.forth
			end
			res.write_header ({HTTP_STATUS_CODE}.method_not_allowed, <<["Allow", s]>>)
		end

	execute_application (a_hdl_context: REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute request handler
		deferred
		end

	pre_execute (req: WGI_REQUEST)
			-- Operation processed before `execute'
		do
			--| To be redefined if needed
		end

	post_execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Operation processed after `execute'
		do
			--| To be redefined if needed
		end

	rescue_execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Operation processed after a rescue
		do
			--| To be redefined if needed
			post_execute (req, res)
		end

feature -- Execution: report

--	execution_information (req: WGI_REQUEST): detachable REQUEST_HANDLER_CONTEXT
--			-- Execution information related to the request
--		do
--			if attached path_information (req, req.environment.path_info) as info then
--				create Result.make (req.environment.path_info)
--			end
--		end

--	path_information (req: WGI_REQUEST; a_rq_path: STRING): detachable TUPLE [format: detachable STRING; arguments: detachable STRING]
--			-- Information related to `a_path'
--		local
--			l_rq_path: STRING
--			i,p,n: INTEGER
--			l_format, l_args: detachable STRING
--		do
--			l_rq_path := a_rq_path
--			if l_rq_path.count > 0 and then l_rq_path[1] /= '/' then
--				l_rq_path := "/" + l_rq_path
--			end
--			n := l_rq_path.count
--			i := req.environment.path_info.count + 1

--			if format_located_before_parameters then
--					--| path = app-path{.format}/parameters

--				if l_rq_path.valid_index (i) and then l_rq_path[i] = '.' then
--					p := l_rq_path.index_of ('/', i + 1)
--					if p = 0 then
--						p := n + 1
--					else
--						l_args := l_rq_path.substring (p + 1, n)
--					end
--					l_format := l_rq_path.substring (i + 1, p - 1)
--				elseif n > i then
--					check l_rq_path[i] = '/' end
--					l_args := l_rq_path.substring (i + 1, n)
--				end
--			elseif format_located_after_parameters then
--					--| path = app-path/parameters{.format}

--				p := l_rq_path.last_index_of ('.', n)
--				if p > i then
--					l_format := l_rq_path.substring (p + 1, n)
--					l_args := l_rq_path.substring (i + 1, p - 1)
--				elseif n > i then
--					check l_rq_path[i] = '/' end
--					l_format := Void
--					l_args := l_rq_path.substring (i + 1, n)
--				end
--			end
--			if l_format /= Void or l_args /= Void then
--				Result := [l_format, l_args]
--			end
--		end

	url (req: WGI_REQUEST; args: detachable STRING; abs: BOOLEAN): STRING
			-- Associated url based on `path' and `args'
			-- if `abs' then return absolute url
		local
			s: detachable STRING
		do
			s := args
			if s /= Void and then s.count > 0 then
				if s[1] /= '/' then
					s := req.request_uri + "/" + s
				else
					s := req.request_uri + s
				end
			else
				s := req.request_uri
			end
			if abs then
				Result := req.absolute_script_url (s)
			else
				Result := req.script_url (s)
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Element change

	set_description (s: like description)
			-- Set `description' to `s'
		do
			description := s
		end

feature {NONE} -- Implementation

	supported_request_methods: INTEGER
			-- Support request method such as GET, POST, ...

feature {NONE} -- Status report

	request_method_id_supported (a_id: INTEGER): BOOLEAN
		do
			Result := (supported_request_methods & a_id) = a_id
		end

	request_method_name_supported (n: STRING): BOOLEAN
			-- Is request method `n' supported?
		do
			Result := request_method_id_supported (request_method_constants.method_id (n))
		end

	request_method_constants: HTTP_REQUEST_METHOD_CONSTANTS
		once
			create Result
		end

feature -- Status report

	supported_request_method_names: LIST [STRING]
			-- Support request method such as GET, POST, ...
		do
			create {LINKED_LIST [STRING]} Result.make
			if method_get_supported then
				Result.extend (request_method_constants.method_get_name)
			end
			if method_post_supported then
				Result.extend (request_method_constants.method_post_name)
			end
			if method_put_supported then
				Result.extend (request_method_constants.method_put_name)
			end
			if method_delete_supported then
				Result.extend (request_method_constants.method_delete_name)
			end
			if method_head_supported then
				Result.extend (request_method_constants.method_head_name)
			end
		end

	method_get_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.method_get)
		end

	method_post_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.method_post)
		end

	method_put_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.method_put)
		end

	method_delete_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.method_delete)
		end

	method_head_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.method_head)
		end

feature -- Element change: request methods		

	reset_supported_request_methods
		do
			supported_request_methods := 0
		end

	enable_request_method_get
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.method_get)
		end

	enable_request_method_post
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.method_post)
		end

	enable_request_method_put
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.method_put)
		end

	enable_request_method_delete
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.method_delete)
		end

	enable_request_method_head
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.method_head)
		end

	enable_request_method (m: INTEGER)
		do
			supported_request_methods := supported_request_methods | m
		end

note
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
