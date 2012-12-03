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

	WSF_SELF_DOCUMENTED_HANDLER

create
	make,
	make_hidden

feature {NONE} -- Initialization

	make (a_router: WSF_ROUTER)
		do
			router := a_router
		end

	make_hidden (a_router: WSF_ROUTER)
		do
			make (a_router)
			is_hidden := True
		end

	router: WSF_ROUTER

	resource: detachable STRING

	is_hidden: BOOLEAN
			-- Current mapped handler should be hidden from self documentation

feature -- Documentation

	mapping_documentation (m: WSF_ROUTER_MAPPING): WSF_ROUTER_MAPPING_DOCUMENTATION
		do
			create Result.make (m)
			Result.set_is_hidden (is_hidden)
			Result.add_description ("Self generated documentation based on the router's setup")
		end

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
