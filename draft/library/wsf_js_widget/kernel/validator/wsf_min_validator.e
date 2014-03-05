note
	description: "[
		Validator implementation which make sure that the input is at least x long.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MIN_VALIDATOR [G -> FINITE [ANY]]

inherit

	WSF_VALIDATOR [G]
		rename
			make as make_validator
		redefine
			state
		end

create
	make

feature {NONE} -- Initialization

	make (m: INTEGER; e: STRING_32)
			-- Initialize with specified minimum and error message which will be displayed on validation failure
		do
			make_validator (e)
			min := m
		end

feature -- Implementation

	is_valid (input: G): BOOLEAN
		do
			Result := input.count > min or input.count = min
		end

feature -- State

	state: WSF_JSON_OBJECT
		do
			Result := Precursor
			Result.put_integer (min, "min")
		end

feature -- Properties

	min: INTEGER
			-- The minimal allowed value

end
