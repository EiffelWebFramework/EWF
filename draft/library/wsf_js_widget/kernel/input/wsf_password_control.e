note
	description: "[
		This control represents an HTML input control with the 'type'
		attribute set to 'password'.
	]"
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

	make (v: STRING_32)
			-- Initialize with specified control name and text
		do
			make_input (v)
			type := "password"
		end

end
