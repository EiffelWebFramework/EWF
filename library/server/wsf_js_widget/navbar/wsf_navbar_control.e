note
	description: "Summary description for {WSF_NAVBAR_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVBAR_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL

create
	make_navbar

feature {NONE} -- Initialization

	make_navbar (b: STRING)
			-- Initialize with specified brand string
		local
			container: WSF_STATELESS_MULTI_CONTROL
			header: WSF_STATELESS_MULTI_CONTROL
			collapse_button: WSF_STATELESS_MULTI_CONTROL
			brand: WSF_BASIC_CONTROL
			icon_bar: WSF_BASIC_CONTROL
		do
			make_multi_control
			add_class ("navbar navbar-inverse navbar-fixed-top")
			create container.make_multi_control
			create header.make_multi_control
			create collapse_button.make_with_tag_name ("button")
			create collapse.make_multi_control
			create nav.make_with_tag_name ("ul")
			create nav_right.make_with_tag_name ("ul")
			create brand.make_control ("a")
			create icon_bar.make_control ("span")
			container.add_class ("container")
			header.add_class ("navbar-header")
			collapse_button.add_class ("navbar-toggle")
			icon_bar.add_class ("icon-bar")
			collapse_button.add_control (icon_bar)
			collapse_button.add_control (icon_bar)
			collapse_button.add_control (icon_bar)
			brand.add_class ("navbar-brand")
			brand.set_attributes ("href=%"#%"")
			brand.set_body (b)
			header.add_control (collapse_button)
			header.add_control (brand)
			nav.add_class ("nav navbar-nav")
			nav_right.add_class ("nav navbar-nav navbar-right")
			collapse.add_class ("navbar-collapse")
			collapse.add_control (nav)
			collapse.add_control (nav_right)
			container.add_control (header)
			container.add_control (collapse)
			add_control (container)
		end

feature -- Properties

	collapse: WSF_STATELESS_MULTI_CONTROL
			-- Content of collapsable navbar

	nav: WSF_STATELESS_MULTI_CONTROL
			-- Middle nav

	nav_right: WSF_STATELESS_MULTI_CONTROL
			-- Right nav

end
