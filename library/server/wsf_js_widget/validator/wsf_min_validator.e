note
	description: "Summary description for {WSF_MIN_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MIN_VALIDATOR [G]

inherit

	WSF_VALIDATOR [LIST [G]]
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

	is_valid (input: LIST [G]): BOOLEAN
		do
			Result := input.count > min or input.count = min
		end

feature -- State

	state: JSON_OBJECT
		do
			Result := Precursor
			Result.put (create {JSON_NUMBER}.make_integer (min), "min")
		end

feature -- Propertiess

	min: INTEGER
			-- The minimal allowed value

end
