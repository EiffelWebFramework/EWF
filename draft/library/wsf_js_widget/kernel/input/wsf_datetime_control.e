note
	description: "Summary description for {WSF_DATETIME_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DATETIME_CONTROL

inherit

	WSF_INPUT_CONTROL
		rename
			make as make_input
		end

create
	make

feature {NONE} -- Initialization

	make (v: STRING)
			-- Initialize with specified control name and text
		do
			make_input (v)
		end

end
