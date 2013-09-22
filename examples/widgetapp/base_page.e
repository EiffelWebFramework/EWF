note
	description: "Summary description for {BASE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BASE_PAGE

inherit

	WSF_PAGE_CONTROL

feature

	initialize_controls
		local
			navbar: WSF_NAVBAR_CONTROL
		do
			create container.make_multi_control ("container")
			container.add_class ("container")
			create navbar.make_navbar ("Sample Page")
			navbar.nav.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			navbar.nav.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/grid%"", "Grid"))
			navbar.nav.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/repeater%"", "Repeater"))
			navbar.nav_right.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"#%"", "About"))
			container.add_control (navbar)
			control := container
		end

feature

	container: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]

end
