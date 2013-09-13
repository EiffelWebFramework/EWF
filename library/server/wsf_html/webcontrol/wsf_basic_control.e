note
	description: "Summary description for {WSF_BASIC_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BASIC_CONTROL

inherit

	WSF_STATELESS_CONTROL

create
	make_control

feature {NONE} -- Initialization

	attributes: STRING

	content: STRING

	make_control (t: STRING)
		do
			make (t)
			attributes := ""
			content := ""
		end

feature -- Rendering

	render: STRING
		do
			Result := render_tag (content, attributes)
		end

feature

	set_attributes (a: STRING)
		do
			attributes := a
		end

	set_content (c: STRING)
		do
			content := c
		end

end
