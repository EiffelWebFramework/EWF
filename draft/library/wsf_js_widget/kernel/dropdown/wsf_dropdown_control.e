note
	description: "Summary description for {WSF_DROPDOWN_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DROPDOWN_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control
		end

create
	make

feature {NONE} -- Initialization

	make (n: STRING)
		do
			make_multi_control (n)
		end

end
