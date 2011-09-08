note
	description: "Summary description for {ROUTED_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ROUTED_APPLICATION

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

	router: REQUEST_ROUTER
			-- Request router

feature -- Execution

	execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			if attached router.dispatch (req, res) as r then
				--| done
			else
				execute_default (req, res)
			end
		end

	execute_default (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		deferred
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
