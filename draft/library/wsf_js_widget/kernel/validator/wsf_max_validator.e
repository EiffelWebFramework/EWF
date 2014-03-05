note
	description: "[
		Validator implementation which make sure that the input is at most x long.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MAX_VALIDATOR [G -> FINITE [ANY]]

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
			-- Initialize with specified maximum and error message which will be displayed on validation failure
		do
			make_validator (e)
			max := m
		end

feature -- Implementation

	is_valid (input: G): BOOLEAN
		do
			Result := input.count < max or input.count = max
		end

feature -- State

	state: WSF_JSON_OBJECT
		do
			Result := Precursor
			Result.put_integer (max, "max")
		end

feature -- Properties

	max: INTEGER
			-- The maximal allowed value

end
