note
	description: "Summary description for {WSF_CHECKBOX_LIST_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_CHECKBOX_LIST_CONTROL

inherit

	WSF_MULTI_CONTROL[WSF_CHECKBOX_CONTROL]

create
	make_checkbox_list_control

feature {NONE}

	make_checkbox_list_control (n: STRING)
		do
			make_multi_control (n)
		end

end
