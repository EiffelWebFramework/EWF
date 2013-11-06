note
	description: "Summary description for {BASE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BASE_PAGE

inherit

	WSF_PAGE_CONTROL
		redefine
			control
		end

feature

	initialize_controls
		local
			btn: WSF_BUTTON_CONTROL
			dropdown:WSF_DROPDOWN_CONTROL
		do
			create control.make ("container")
			control.add_class ("container")
			create dropdown.make_with_tag_name ( "Dropdown", "li")
			dropdown.add_link_item ("Example link 1", "#")
			dropdown.add_divider
			dropdown.add_link_item ("Example link 2", "#")
			create navbar.make_with_brand ("navbar1", "Example")
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/grid%"", "Grid"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/repeater%"", "Repeater"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/slider%"", "Slider"))
			navbar.add_element (dropdown)
			navbar.add_list_element_right (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/about%"", "About"))
			create btn.make ("scode", "Show Code")
			btn.set_click_event (agent show_code)
			btn.set_isolation (true)
			btn.add_class ("btn-success")
			control.add_control (btn)
			if not attached get_parameter ("ajax") then
				control.add_control (navbar)
			end
		end

	show_code
		do
			start_modal_big ("/codeview?file=" + generator.as_lower, "Eiffel code " + generator)
		end

feature

	control: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]

	navbar: WSF_NAVBAR_CONTROL

end
