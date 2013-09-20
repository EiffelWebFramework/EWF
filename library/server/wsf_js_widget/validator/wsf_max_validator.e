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

feature {NONE}

	make_max_validator (m: INTEGER; e: STRING)
		do
			make (e)
			max := m
		end

feature -- Implementation

	is_valid (input: LIST [G]): BOOLEAN
		do
			Result := input.count < max or input.count = max
		end

feature

	state: JSON_OBJECT
		do
			Result := Precursor
			Result.put (create {JSON_NUMBER}.make_integer (max), "max")
		end

	max: INTEGER

end
