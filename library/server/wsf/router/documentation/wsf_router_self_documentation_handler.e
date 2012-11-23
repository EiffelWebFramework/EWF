note
	description: "[
			Handler based on a STARTS_WITH handler to respond a 
			WSF_ROUTER_SELF_DOCUMENTATION_MESSAGE message
			
			This is a self documentation for WSF_ROUTER.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ROUTER_SELF_DOCUMENTATION_HANDLER

inherit
	WSF_STARTS_WITH_HANDLER
		redefine
			on_mapped
		end

create
	make

feature {NONE} -- Initialization

	make (a_router: WSF_ROUTER)
		do
			router := a_router
		end

	router: WSF_ROUTER

	resource: detachable STRING

feature {WSF_ROUTER} -- Mapping

	on_mapped (a_mapping: WSF_ROUTER_MAPPING; a_rqst_methods: detachable WSF_ROUTER_METHODS)
			-- Callback called when a router map a route to Current handler
		do
			if attached {WSF_STARTS_WITH_MAPPING} a_mapping as m then
				resource := m.uri
			end
		end

feature -- Execution

	execute (a_start_path: READABLE_STRING_8; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			m: WSF_ROUTER_SELF_DOCUMENTATION_MESSAGE
		do
			if attached resource as l_resource then
				create m.make_with_resource (req, router, l_resource)
			else
				create m.make (req, router)
			end
			res.send (m)
		end

end
