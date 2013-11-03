note
	description: "Summary description for {WSF_NAVBAR_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVBAR_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control
		redefine
			render
		end

create
	make, make_with_brand

feature {NONE} -- Initialization

	make (n: STRING)
			--Initialize
		do
			make_multi_control (n)
			active_set := false
			add_class ("navbar navbar-inverse navbar-fixed-top")
			create nav.make_with_tag_name (control_name + "_nav", "ul")
			create nav_right.make_with_tag_name (control_name + "_nav_right", "ul")
			controls.extend (nav)
			controls.extend (nav_right)
			nav.add_class ("nav navbar-nav")
			nav_right.add_class ("nav navbar-nav navbar-right")
		end

	make_with_brand (n, b: STRING)
			-- Initialize with specified brand string
		do
			make (n)
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
			-- Sets the given tab as current active tab
		require
			tab >= 1 and tab <= tab_count and not active_set
		do
			if tab <= nav.controls.count then
				nav.controls.i_th (tab).add_class ("active")
			else
				nav_right.controls.i_th (tab - nav.controls.count).add_class ("active")
			end
			active_set := true
		end

	add_dropdown (l: WSF_STATELESS_CONTROL; d: WSF_STATELESS_CONTROL)
			-- Add dropdown menu (in li tag with class dropdown) to navbar
		local
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name (control_name + "_link" + nav.controls.count.out, "li")
			li.add_class ("dropdown")
			li.add_control (l)
			li.add_control (d)
			add_element (li)
		end

	add_dropdown_right (l: WSF_STATELESS_CONTROL; d: WSF_STATELESS_CONTROL)
			-- Add dropdown menu (in li tag with class dropdown) to right aligned part of navbar
		local
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name (control_name + "_link" + nav.controls.count.out, "li")
			li.add_class ("dropdown")
			li.add_control (l)
			li.add_control (d)
			add_element_right (li)
		end

	add_list_element_right (l: WSF_STATELESS_CONTROL)
			-- Add element in li tag to right aligned part of navbar
		local
			name: STRING
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			name := control_name + "_rightlink";
			name := name + nav_right.controls.count.out
			create li.make_with_tag_name (name, "li")
			li.add_control (l)
			add_element_right (li)
		end

	add_list_element (l: WSF_STATELESS_CONTROL)
			-- Add element in li tag to main nav
		local
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name (control_name + "_link" + nav.controls.count.out, "li")
			li.add_control (l)
			add_element (li)
		end

	add_element_right (c: WSF_STATELESS_CONTROL)
			-- Add element to right aligned part of navbar
		do
			nav_right.add_control (c)
		end

	add_element (c: WSF_STATELESS_CONTROL)
			-- Add element to main nav
		do
			nav.add_control (c)
		end

feature -- Access

	tab_count: INTEGER
			-- Current sum of the number of items in left and right navbar
		do
			Result := nav.controls.count + nav_right.controls.count
		end

feature -- Properties

	active_set: BOOLEAN
			-- This flag is set once a tab has been set as active tab

	brand: detachable STRING
			-- Optional brand of the navbar

	nav: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- Middle nav

	nav_right: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- Right nav

end
