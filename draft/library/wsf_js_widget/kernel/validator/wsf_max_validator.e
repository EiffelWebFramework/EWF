note
	description: "Summary description for {WSF_MAX_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_max_VALIDATOR [G]

inherit

	WSF_VALIDATOR [LIST [G]]
		redefine
			state
		end

create
	make_max_validator

feature {NONE} -- Initialization

	make_max_validator (m: INTEGER; e: STRING)
			-- Initialize with specified maximum and error message which will be displayed on validation failure
		do
			make (e)
			max := m
		end

feature -- Implementation

	is_valid (input: LIST [G]): BOOLEAN
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
