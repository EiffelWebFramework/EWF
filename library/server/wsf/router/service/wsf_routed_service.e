note
	description: "Summary description for {WSF_ROUTED_SERVICE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_ROUTED_SERVICE

feature -- Initialization

	initialize_router
		do
			create_router
			setup_router
		end

	create_router
			-- Create `router'	
		do
			create router.make (10)
		ensure
			router_created: router /= Void
		end

	setup_router
			-- Setup `router'
		require
			router_created: router /= Void
		deferred
		end

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if attached router.dispatch_and_return_handler (req, res) as p then
				-- executed
			else
				execute_default (req, res)
			end
		end

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
		deferred
		end

feature -- Access

	router: WSF_ROUTER

;note
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
