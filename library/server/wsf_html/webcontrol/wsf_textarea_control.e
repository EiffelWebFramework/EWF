note
	description: "Summary description for {WSF_TEXT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_TEXTAREA_CONTROL

inherit

	WSF_INPUT_CONTROL
		redefine
			render
		end

create
	make_textarea

feature {NONE}

	make_textarea (n, t: STRING)
		do
			make_input (n, t)
			tag_name := "textarea"
		end

feature

	render: STRING
		do
			Result := render_tag (text, "")
		end

end
