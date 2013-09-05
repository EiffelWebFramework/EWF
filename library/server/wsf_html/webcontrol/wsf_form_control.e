note
	description: "Summary description for {WSF_FORM_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_CONTROL

inherit

	WSF_MULTI_CONTROL

create
	make_form_control

feature {NONE}

	make_form_control (n: STRING)
		do
			make_multi_control (n)
			tag_name := "form"
		end

feature

	

end
