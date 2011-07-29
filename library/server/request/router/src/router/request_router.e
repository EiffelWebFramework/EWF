note
	description: "Summary description for {REQUEST_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_ROUTER

feature -- Registration

	map_default (r: like default_handler)
			-- Map default handler
			-- If no route/handler is found,
			-- then use `default_handler' as default if not Void
		do
			default_handler := r
		end

	map (a_id: STRING; h: REQUEST_HANDLER)
			-- Map handler `h' with `a_id'
		deferred
		end

	map_agent (a_id: STRING; a_action: like {REQUEST_AGENT_HANDLER}.action)
		local
			h: REQUEST_AGENT_HANDLER
		do
			create h.make (a_action)
			map (a_id, h)
		end

feature -- Execution

	dispatch (req: EWSGI_REQUEST; res: EWSGI_RESPONSE_STREAM): detachable REQUEST_HANDLER
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

	handler (req: EWSGI_REQUEST): detachable TUPLE [handler: REQUEST_HANDLER; context: REQUEST_HANDLER_CONTEXT]
			-- Handler whose map matched with `req'
		require
			req_valid: req /= Void and then req.environment.path_info /= Void
		deferred
		ensure
			req_path_info_unchanged: req.environment.path_info.same_string (old req.environment.path_info)
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
