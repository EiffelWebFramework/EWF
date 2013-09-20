note
	description: "Summary description for {WSF_MIN_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MIN_VALIDATOR[G]

inherit
	WSF_VALIDATOR [LIST[G]]
		redefine
			state
		end

create
	make_min_validator

feature {NONE}

	make_min_validator (m:INTEGER; e: STRING)
		do
			make (e)
			min := m
		end

feature -- Implementation

	is_valid (input:LIST[G]): BOOLEAN
		do
			Result:= input.count > min or input.count = min

		end

feature

	state: JSON_OBJECT
		do
			Result := Precursor
			Result.put (create {JSON_NUMBER}.make_integer (min), "min")
		end

	min: INTEGER

end
