note
	description: "Summary description for {ROUTED_SERVICE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ROUTED_SERVICE_I [H -> REQUEST_HANDLER [C], C -> REQUEST_HANDLER_CONTEXT]

feature -- Setup

	initialize_router
			-- Initialize `router'
		do
			create_router
			setup_router
		end

	create_router
			-- Create `router'	
		deferred
		ensure
			router_created: router /= Void
		end

	setup_router
			-- Setup `router'
		require
			router_created: router /= Void
		deferred
		end

	router: REQUEST_ROUTER [H, C]
			-- Request router

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_handled: BOOLEAN
			rescued: BOOLEAN
		do
			if not rescued then
				l_handled := router.dispatch (req, res)
				if not l_handled then
					execute_default (req, res)
				end
			else
				execute_rescue (req, res)
			end
		end

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
		deferred
		end

	execute_rescue (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if not res.header_committed then
				res.put_header ({HTTP_STATUS_CODE}.internal_server_error, Void)
			end
			res.flush
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
