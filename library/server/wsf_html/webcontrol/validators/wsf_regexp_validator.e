note
	description: "Summary description for {WSF_REGEXP_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_REGEXP_VALIDATOR

inherit

	WSF_VALIDATOR [STRING]

create
	make_regexp_validator

feature {NONE}

	make_regexp_validator (r, e: STRING)
		do
			make(e)
			regexp_string := r
			create regexp
			regexp.compile (r)
		end

feature -- Implementation

	validate (input: STRING): BOOLEAN
		do
			Result := regexp.matches (input)
		end

feature

	regexp_string: STRING

	regexp: REGULAR_EXPRESSION

end
