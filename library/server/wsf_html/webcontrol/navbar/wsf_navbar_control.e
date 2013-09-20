note
	description: "Summary description for {WSF_NAVBAR_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVBAR_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]

create
	make_navbar

feature

	collapse: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]

	nav: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]

	nav_right: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]

feature

	add_element (c: WSF_STATELESS_CONTROL)
		do
			add_element_to_nav (c, nav)
		end

	add_element_right (c: WSF_STATELESS_CONTROL)
		do
			add_element_to_nav (c, nav_right)
		end

	add_element_to_nav (e: WSF_STATELESS_CONTROL; n: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL])
		local
			li: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name ("li")
			li.add_control (e)
			n.add_control (li)
		end

feature {NONE} -- Initialization

	make_navbar (b: STRING)
		local
			container: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			header: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			collapse_button: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
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
--			collapse_button.set_attributes ("data-target=%".navbar-collapse%" data-toggle=%"collapse%" type=%"button%"")
			brand.add_class ("navbar-brand")
			brand.set_attributes ("href=%"#%"")
			brand.set_content (b)
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

end
