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
			control,
			initialize_controls
		end

feature

	initialize_controls
		do
			create control.make
			control.add_class ("container")
			create navbar.make_with_brand ("EWF JS CUSTOM WIDGET")
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			create main_control.make
			control.add_control (navbar)
			control.add_control (main_control)
		end


feature -- Properties

	main_control: WSF_LAYOUT_CONTROL

	control: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]

	navbar: WSF_NAVBAR_CONTROL

end
