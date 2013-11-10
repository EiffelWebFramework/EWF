note
	description: "Summary description for {WSF_MIN_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MIN_VALIDATOR [G->FINITE[ANY]]

inherit

	WSF_VALIDATOR [G]
		redefine
			state
		end

create
	make_min_validator

feature {NONE} -- Initialization

	make_min_validator (m: INTEGER; e: STRING)
			-- Initialize with specified minimum and error message which will be displayed on validation failure
		do
			make (e)
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
