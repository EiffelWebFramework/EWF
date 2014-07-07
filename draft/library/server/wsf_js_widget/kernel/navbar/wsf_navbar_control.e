note
	description: "[
		WSF_NAVBAR_CONTROL encapsulates the navbar provided by
		bootstrap. Simple menu items as well as dropdown lists and
		panels can be added to this control.
		See http://getbootstrap.com/components/#navbar
	]"
	EIS: "name=Bootstrap navbar", "protocol=URI", "src=http://getbootstrap.com/components/#navbar"
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

	make
			-- Initialize
		do
			make_multi_control
			active_set := False
			add_class ("navbar navbar-inverse navbar-fixed-top")
			create nav.make_with_tag_name ("ul")
			create nav_right.make_with_tag_name ("ul")
			add_control (nav)
			add_control (nav_right)
			nav.add_class ("nav navbar-nav")
			nav_right.add_class ("nav navbar-nav navbar-right")
		end

	make_with_brand (a_brand: READABLE_STRING_32)
			-- Initialize with specified `a_brand' string.
		do
			make
			brand := a_brand
		ensure
			brand_set: brand = a_brand
		end

feature -- Rendering

	render: STRING_32
		local
			temp: STRING_32
			nav_string: STRING_32
		do
			temp := render_tag_with_tagname ("span", "", "", "icon-bar")
			temp.multiply (3)
			temp := render_tag_with_tagname ("button", temp, "data-target=%".navbar-collapse%" data-toggle=%"collapse%" type=%"button%"", "navbar-toggle")
			if attached brand as l_brand then
				temp.append (render_tag_with_tagname ("a", l_brand, "href=%"#%"", "navbar-brand"))
			end
			temp := render_tag_with_tagname ("div", temp, "", "navbar-header")
			nav_string := nav.render
			if nav_right.controls.count > 0 then
				nav_string.append (nav_right.render)
			end
			temp.append (render_tag_with_tagname ("div", nav_string, "", "navbar-collapse collapse"))
			Result := render_tag_with_tagname ("div", temp, "", "container")
			Result := render_tag (Result, "")
		end

feature -- Change

	set_active (tab: INTEGER)
			-- Sets the given tab as current active tab. This procedure must not be called more than once.
		require
			tab >= 1 and tab <= tab_count and not active_set
		do
			if tab <= nav.controls.count then
				nav.controls.i_th (tab).add_class ("active")
			else
				nav_right.controls.i_th (tab - nav.controls.count).add_class ("active")
			end
			active_set := true
		ensure
			active_set_set: active_set
		end

	add_list_element_right (a_control: WSF_STATELESS_CONTROL)
			-- Add element in li tag to right aligned part of navbar
		local
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name ("li")
			li.add_control (a_control)
			add_element_right (li)
		end

	add_list_element (a_control: WSF_STATELESS_CONTROL)
			-- Add element in li tag to main nav
		local
			li: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create li.make_with_tag_name ("li")
			li.add_control (a_control)
			add_element (li)
		end

	add_element_right (a_control: WSF_STATELESS_CONTROL)
			-- Add element to right aligned part of navbar
		do
			nav_right.add_control (a_control)
		end

	add_element (a_control: WSF_STATELESS_CONTROL)
			-- Add element to main nav
		do
			nav.add_control (a_control)
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

	brand: detachable READABLE_STRING_32
			-- Optional brand of the navbar

	nav: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- Middle nav

	nav_right: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- Right nav

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
