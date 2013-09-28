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
			navbar: WSF_NAVBAR_CONTROL
			btn: WSF_BUTTON_CONTROL
		do
			create control.make_multi_control ("container")
			control.add_class ("container")
			create navbar.make_navbar_with_brand ("navbar1", "Example")
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/grid%"", "Grid"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/repeater%"", "Repeater"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/slider%"", "Image Slider"))
			create btn.make_button ("scode", "Show Code")
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

end
