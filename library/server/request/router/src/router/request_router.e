note
	description: "Summary description for {REQUEST_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_ROUTER [H -> REQUEST_HANDLER [C], C -> REQUEST_HANDLER_CONTEXT]

feature -- Mapping

	map_default (r: like default_handler)
			-- Map default handler
			-- If no route/handler is found,
			-- then use `default_handler' as default if not Void
		do
			set_default_handler (r)
		end

	map (a_id: READABLE_STRING_8; h: H)
			-- Map handler `h' with `a_id'
		do
			map_with_request_methods (a_id, h, Void)
		end

	map_with_request_methods (a_id: READABLE_STRING_8; h: H; rqst_methods: detachable ARRAY [READABLE_STRING_8])
			-- Map handler `h' with `a_id' and `rqst_methods'
		deferred
		end

	map_agent (a_id: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER]])
		do
			map_agent_with_request_methods (a_id, a_action, Void)
		end

	map_agent_with_request_methods (a_id: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER]];
			 rqst_methods: detachable ARRAY [READABLE_STRING_8])
		local
			rah: REQUEST_AGENT_HANDLER [C]
		do
			create rah.make (a_action)
			if attached {H} rah as h then
				map_with_request_methods (a_id, h, rqst_methods)
			else
				check valid_agent_handler: False end
			end
		end

feature -- Execution

	dispatch (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER): BOOLEAN
			-- Dispatch `req, res' to the associated handler
			-- And return True is handled, otherwise False
		do
			Result := dispatch_and_return_handler (req, res) /= Void
		end

	dispatch_and_return_handler (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER): detachable H
			-- Dispatch `req, res' to the associated handler
			-- And return this handler
			-- If Result is Void, this means no handler was found.
		local
			d: like handler
			ctx: detachable like default_handler_context
		do
			d := handler (req)
			if d /= Void then
				Result := d.handler
				ctx := d.context
			else
				Result := default_handler
				if Result /= Void then
					ctx := default_handler_context (req)
				end
			end
			if Result /= Void and ctx /= Void then
				Result.execute (ctx, req, res)
			end
		ensure
			result_void_implie_no_default: Result = Void implies default_handler = Void
		end

feature -- Traversing

	new_cursor: ITERATION_CURSOR [TUPLE [handler: H; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Fresh cursor associated with current structure
		deferred
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Access: Implementation

	handler (req: WGI_REQUEST): detachable TUPLE [handler: H; context: like default_handler_context]
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

	set_default_handler (h: like default_handler)
			-- Set `default_handler' to `h'
		deferred
		ensure
			default_handler_set: h = default_handler
		end

	default_handler: detachable H
			-- Default handler
		deferred
		end

	default_handler_context (req: WGI_REQUEST): C
			-- Default handler context associated with `default_handler'
		require
			has_default_handler: default_handler /= Void
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
