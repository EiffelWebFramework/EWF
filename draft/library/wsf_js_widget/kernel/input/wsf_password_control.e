note
	description: "Summary description for {WSF_PASSWORD_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PASSWORD_CONTROL

inherit

	WSF_INPUT_CONTROL
		rename
			make as make_input
		end

create
	make

feature {NONE} -- Initialization

	make (n, v: STRING)
			-- Initialize with specified control name and text
		do
			make_input (n, v)
			type := "password"
		end

end
