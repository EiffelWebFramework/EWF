note
	description: "Summary description for {WSF_NAVBAR_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVBAR_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		redefine
			render
		end

create
	make_navbar, make_navbar_with_brand

feature {NONE} -- Initialization

	make_navbar (n: STRING)
			--Initialize
		do
			make_multi_control (n)
			add_class ("navbar navbar-inverse navbar-fixed-top")
			create nav.make_with_tag_name (control_name + "_nav", "ul")
			create nav_right.make_with_tag_name (control_name + "_nav_right", "ul")
			nav.add_class ("nav navbar-nav")
		end

	make_navbar_with_brand (n, b: STRING)
			-- Initialize with specified brand string
		do
			make_navbar (n)
			brand := b
		end

feature -- Rendering

	render: STRING
		local
			temp: STRING
			nav_string: STRING
		do
			temp := render_tag_with_tagname ("span", "", "", "icon-bar")
			temp.multiply (3)
			temp := render_tag_with_tagname ("button", temp, "", "navbar-toggle")
			if attached brand as b then
				temp.append (render_tag_with_tagname ("a", b, "href=%"#%"", "navbar-brand"))
			end
			temp := render_tag_with_tagname ("div", temp, "", "navbar-header")
			nav_string := nav.render
			if nav_right.controls.count > 0 then
				nav_string.append (nav_right.render)
			end
			temp.append (render_tag_with_tagname ("div", nav_string, "", "navbar-collapse"))
			Result := render_tag_with_tagname ("div", temp, "", "container")
			Result := render_tag (Result, "")
		end

feature -- Change

	set_active (tab: INTEGER)
		require
			tab >= 0 and tab < nav.controls.count + nav_right.controls.count
		do
			if tab < nav.controls.count then
				nav.controls.i_th (tab).add_class ("active")
			else
				nav_right.controls.i_th (tab - nav.controls.count).add_class ("active")
			end
		end

	add_list_element_right (c: WSF_STATELESS_CONTROL)
			-- Add element in li tag to right aligned part of navbar
		local
			name: STRING
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			name := control_name + "_rightlink";
			name := name + nav_right.controls.count.out
			create li.make_with_tag_name (name, "li")
			li.add_control (c)
			add_element_right (li)
		end

	add_list_element (c: WSF_STATELESS_CONTROL)
			-- Add element in li tag to main nav
		local
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name (control_name + "_link" + nav.controls.count.out, "li")
			li.add_control (c)
			add_element (li)
		end

	add_element_right (c: WSF_STATELESS_CONTROL)
			-- Add element to right aligned part of navbar
		local
			right: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			if attached nav_right as r then
				right := r
			else
				create right.make_with_tag_name (control_name + "_rightnav", "ul")
				right.add_class ("nav navbar-nav navbar-right")
				nav_right := right
			end
			right.add_control (c)
		end

	add_element (c: WSF_STATELESS_CONTROL)
			-- Add element to main nav
		do
			nav.add_control (c)
		end

feature -- Properties

	brand: detachable STRING
			-- Optional brand of the navbar

	nav: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- Middle nav

	nav_right: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- Right nav

end
