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

	make (tag: STRING_32)
			-- Initialize
		require
			tag_not_empty: not tag.is_empty
		do
			make_with_body_class (tag, "", "", "")
		end

	make_with_body (tag, attr, b: STRING_32)
			-- Initialize with specific attributes and body
		require
			tag_not_empty: not tag.is_empty
		do
			make_stateless_control (tag)
			attributes := attr
			body := b
		end

	make_with_body_class (tag, attr, c, b: STRING_32)
			-- Initialize with specific class, attributes and body
		require
			tag_not_empty: not tag.is_empty
		do
			make_with_body (tag, attr, b)
			if not c.is_empty then
				css_classes.extend (c)
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

end
