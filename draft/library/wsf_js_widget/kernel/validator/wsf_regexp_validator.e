note
	description: "[
		Validator implementation which validates the input based on a given regular expression
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_REGEXP_VALIDATOR

inherit

	WSF_VALIDATOR [STRING_32]
		rename
			make as make_validator
		redefine
			state
		end

create
	make

feature {NONE} -- Initialization

	make (r, e: STRING_32)
			-- Initialize with specified regular expression and error message which will be displayed on validation failure
		do
			make_validator (e)
			regexp_string := r
			create regexp
			ensure regexp_string_set: regexp_string = r
		end

feature -- Implementation

	is_valid (input: STRING_32): BOOLEAN
		do
				--Only compile when used
			if not regexp.is_compiled then
				regexp.compile (regexp_string)
			end
			Result := (not input.is_empty) and regexp.matches (input)
		end

feature -- State

	state: WSF_JSON_OBJECT
		do
			create Result.make
			Result.put_string ("WSF_REGEXP_VALIDATOR", "name")
			Result.put_string (regexp_string, "expression")
			Result.put_string (error, "error")
		end

feature -- Properties

	regexp_string: STRING_32
			-- The regexp in string representation

	regexp: REGULAR_EXPRESSION
			-- The regexp of this validator

end
