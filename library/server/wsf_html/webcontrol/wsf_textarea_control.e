note
	description: "Summary description for {WSF_TEXT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_TEXTAREA_CONTROL

inherit

	WSF_TEXT_CONTROL

create
	make_textarea

feature {NONE}

	make_textarea (n, t: STRING)
		do
			make_text (n, t)
		    tag_name := "textarea"
		end
end
