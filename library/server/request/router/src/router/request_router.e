note
	description: "Summary description for {REQUEST_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_ROUTER

inherit
	ITERABLE [TUPLE [handler: REQUEST_HANDLER; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]

feature -- Registration

	map_default (r: like default_handler)
			-- Map default handler
			-- If no route/handler is found,
			-- then use `default_handler' as default if not Void
		do
			default_handler := r
		end

	map (a_id: READABLE_STRING_8; h: REQUEST_HANDLER)
			-- Map handler `h' with `a_id'
		do
			map_with_request_methods (a_id, h, Void)
		end

	map_with_request_methods (a_id: READABLE_STRING_8; h: REQUEST_HANDLER; rqst_methods: detachable ARRAY [READABLE_STRING_8])
			-- Map handler `h' with `a_id' and `rqst_methods'
		deferred
		end

	map_agent (a_id: READABLE_STRING_8; a_action: like {REQUEST_AGENT_HANDLER}.action)
		do
			map_agent_with_request_methods (a_id, a_action, Void)
		end

	map_agent_with_request_methods (a_id: READABLE_STRING_8; a_action: like {REQUEST_AGENT_HANDLER}.action; rqst_methods: detachable ARRAY [READABLE_STRING_8])
		local
			h: REQUEST_AGENT_HANDLER
		do
			create h.make (a_action)
			map_with_request_methods (a_id, h, rqst_methods)
		end

feature -- Execution

	dispatch (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER): detachable REQUEST_HANDLER
			-- Dispatch `req, res' to the associated handler
			-- And return this handler
			-- If Result is Void, this means no handler was found.
		local
			d: like handler
			ctx: detachable REQUEST_HANDLER_CONTEXT
		do
			d := handler (req)
			if d /= Void then
				Result := d.handler
				ctx := d.context
			else
				Result := default_handler
			end
			if Result /= Void then
				if ctx = Void then
					check is_default_handler: Result = default_handler end
					create {REQUEST_URI_HANDLER_CONTEXT} ctx.make (req, "/")
				end
				Result.execute (ctx, req, res)
			end
		ensure
			result_void_implie_no_default: Result = Void implies default_handler = Void
		end

feature {NONE} -- Access: Implementation

	handler (req: WGI_REQUEST): detachable TUPLE [handler: REQUEST_HANDLER; context: REQUEST_HANDLER_CONTEXT]
			-- Handler whose map matched with `req'
		require
			req_valid: req /= Void and then req.path_info /= Void
		deferred
		ensure
			req_path_info_unchanged: req.path_info.same_string (old req.path_info)
		end

	is_matching_request_methods (a_request_method: READABLE_STRING_GENERAL; rqst_methods: like formatted_request_methods): BOOLEAN
			-- `a_request_method' is matching `rqst_methods' contents
		local
			i,n: INTEGER
			m: READABLE_STRING_GENERAL
		do
			if rqst_methods /= Void and then not rqst_methods.is_empty then
				m := a_request_method
				from
					i := rqst_methods.lower
					n := rqst_methods.upper
				until
					i > n or Result
				loop
					Result := m.same_string (rqst_methods[i])
					i := i + 1
				end
			else
				Result := True
			end
		end

	formatted_request_methods (rqst_methods: like formatted_request_methods): detachable ARRAY [READABLE_STRING_8]
			-- Formatted request methods values
		local
			i,l,u: INTEGER
		do
			if rqst_methods /= Void and then not rqst_methods.is_empty then
				l := rqst_methods.lower
				u := rqst_methods.upper
				create Result.make_filled (rqst_methods[l], l, u)
				from
					i := l + 1
				until
					i > u
				loop
					Result[i] := rqst_methods[i].as_string_8.as_upper
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	default_handler: detachable REQUEST_HANDLER
			-- Default handler

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
