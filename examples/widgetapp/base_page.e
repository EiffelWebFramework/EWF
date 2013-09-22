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
			create navbar.make_navbar_with_brand ("Example")
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/grid%"", "Grid"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/repeater%"", "Repeater"))
			navbar.add_list_element_right (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"#%"", "About"))
			if not attached get_parameter ("ajax") then
				container.add_control (navbar)
			end
			control := container
		end

feature

	container: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]

end
