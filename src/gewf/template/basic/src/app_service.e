note
	description: "[
				application service
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end

	WSF_ROUTED_SERVICE

	APPLICATION_LAUNCHER

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			set_service_option ("port", 9090)
			initialize_router
		end

	setup_router
			-- Setup `router'
		local
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			router.handle_with_request_methods ("/doc", create {WSF_ROUTER_SELF_DOCUMENTATION_HANDLER}.make (router), router.methods_GET)
			create fhdl.make_hidden (".")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle_with_request_methods ("", fhdl, router.methods_GET)
		end

end
