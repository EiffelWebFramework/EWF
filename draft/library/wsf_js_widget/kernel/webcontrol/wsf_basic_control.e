note
	description: "Summary description for {WSF_BASIC_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BASIC_CONTROL

inherit

	WSF_STATELESS_CONTROL
		redefine
			attributes
		end

create
	make_control, make_with_body, make_with_body_class

feature {NONE} -- Initialization

	make_control (t: STRING)
			-- Initialize
		do
			make_with_body_class (t, "", "", "")
		end

	make_with_body (t, attr, b: STRING)
			-- Initialize with specific attributes and body
		do
			make (t)
			attributes := attr
			body := b
		end

	make_with_body_class (t, attr, c, b: STRING)
			-- Initialize with specific attributes and body
		do
			make_with_body (t, attr, b)
			if not c.is_empty then
				css_classes.extend (c)
			end
		end

feature -- Rendering

	render: STRING
			-- HTML representation of this control
		do
			Result := render_tag (body, attributes)
		end

feature -- Change

	set_attributes (a: STRING)
			-- Set the attributes string of this control
		do
			attributes := a
		end

	set_body (b: STRING)
			-- Set the body of this control
		do
			body := b
		end

feature -- Access

	attributes: STRING
			-- Attributes of this control

	body: STRING
			-- Body of this control

end
