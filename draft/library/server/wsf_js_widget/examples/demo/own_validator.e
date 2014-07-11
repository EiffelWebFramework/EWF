note
	description: "Summary description for {OWN_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OWN_VALIDATOR

inherit

	WSF_VALIDATOR [STRING_32]

create
	make_own

feature {NONE}

	make_own
		do
			error := "Input too long"
		end

feature

	is_valid (input: STRING_32): BOOLEAN
		do
			Result := input.count < 5
		end

end
