note
	description: "Summary description for {WSF_TEXT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_TEXTAREA_CONTROL

inherit

	WSF_INPUT_CONTROL
		rename
			make as make_input
		redefine
			render
		end

create
	make

feature {NONE} -- Initialization

	make (n, t: STRING)
			-- Initialize with specified control name and text to be displayed in this textarea
		do
			make_input (n, t)
			tag_name := "textarea"
		end

feature -- Rendering

	render: STRING
		do
			Result := render_tag (text, "")
		end

end
