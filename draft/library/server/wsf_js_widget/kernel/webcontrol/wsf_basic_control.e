note
	description: "[
		Represents a simple basic element with a user specified html tag.
		This control is lightweight and can be used to create custom
		stateless controls, e.g. headers.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BASIC_CONTROL

inherit

	WSF_STATELESS_CONTROL
		rename
			make as make_stateless_control
		redefine
			attributes
		end

create
	make, make_with_body, make_with_body_class

feature {NONE} -- Initialization

	make (a_tag: STRING_32)
			-- Initialize
		require
			tag_not_empty: not a_tag.is_empty
		do
			make_with_body_class (a_tag, "", "", "")
		end

	make_with_body (a_tag, a_attribs, a_body: STRING_32)
			-- Initialize with tag `a_tag', specific attributes `a_attribs' and body `a_body'.
		require
			tag_not_empty: not a_tag.is_empty
		do
			make_stateless_control (a_tag)
			attributes := a_attribs
			body := a_body
		end

	make_with_body_class (a_tag, a_attribs, a_css_class, a_body: STRING_32)
			-- Initialize with tag `a_tag' specific class `a_css_class', attributes `a_attribs' and body `a_body'.
		require
			tag_not_empty: not a_tag.is_empty
		do
			make_with_body (a_tag, a_attribs, a_body)
			if not a_css_class.is_empty then
				css_classes.extend (a_css_class)
			end
		end

feature -- Rendering

	render: STRING_32
			-- HTML representation of this control
		do
			Result := render_tag (body, attributes)
		end

feature -- Change

	set_body (b: STRING_32)
			-- Set the body of this control
		do
			body := b
		ensure
			body_set: body = b
		end

feature -- Access

	attributes: STRING_32
			-- Attributes of this control

	body: STRING_32
			-- Body of this control

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
