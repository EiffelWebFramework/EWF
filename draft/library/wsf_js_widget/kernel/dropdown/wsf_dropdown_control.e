note
	description: "Summary description for {WSF_DROPDOWN_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DROPDOWN_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control,
			make_with_tag_name as make_multi_control_with_tag_name
		end

create
	make, make_with_tag_name

feature {NONE} -- Initialization

	make (  title: STRING)
			-- Make a dropdown control with div tag name and specified menu title
		do
			make_with_tag_name (  title, "div")
		end

	make_with_tag_name ( title, t: STRING)
			-- Make a dropdown control with specified tag name and menu title (such as li)
		do
			make_multi_control_with_tag_name ( t)
			add_class ("dropdown")
			create {WSF_BASIC_CONTROL} dropdown_toggle.make_with_body_class ("a", "data-toggle=%"dropdown%" href=%"#%"", "dropdown-toggle", title + " <strong class=%"caret%"></strong>")
			create dropdown_menu.make_with_tag_name ( "ul")
			dropdown_menu.add_class ("dropdown-menu")
			add_control (dropdown_toggle)
			add_control (dropdown_menu)
		end

feature -- Change

	add_item (c: WSF_STATELESS_CONTROL)
		local
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name ("li")
			li.add_control (c)
			dropdown_menu.add_control (li)
		end

	add_link_item (label, link: STRING)
		local
			c: WSF_BASIC_CONTROL
		do
			create c.make_with_body ("a", "href=%"" + link + "%"", label)
			add_item (c)
		end

	add_divider
		do
			dropdown_menu.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("li", "", "divider", ""))
		end

feature -- Properties

	dropdown_toggle: WSF_STATELESS_CONTROL

	dropdown_menu: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]

end
