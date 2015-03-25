note
	description: "Summary description for {WSF_ROUTED_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_ROUTED_EXECUTION

feature -- Router

	initialize_router
			-- Initialize router
		do
			create_router
			setup_router
		end

	create_router
			-- Create `router'	
			--| could be redefine to initialize with proper capacity
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

feature -- Access

	request: WSF_REQUEST
		deferred
		end

	response: WSF_RESPONSE
		deferred
		end

	router: WSF_ROUTER
			-- Router used to dispatch the request according to the WSF_REQUEST object
			-- and associated request methods		

feature -- Execution

	execute
			-- Dispatch the request
			-- and if handler is not found, execute the default procedure `execute_default'.
		local
			sess: WSF_ROUTER_SESSION
		do
			create sess
			router.dispatch (request, response, sess)
			if not sess.dispatched then
				execute_default
			end
		ensure
			response_status_is_set: response.status_is_set
		end

	execute_default
			-- Dispatch requests without a matching handler.
		local
			msg: WSF_DEFAULT_ROUTER_RESPONSE
		do
			create msg.make_with_router (request, router)
			msg.set_documentation_included (True)
			response.send (msg)
		end

end
