note
	description: "Summary description for {WSF_REGEXP_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_REGEXP_VALIDATOR

inherit

	WSF_VALIDATOR [STRING]
		redefine
			state
		end

create
	make_regexp_validator

feature {NONE} -- Initialization

	make_regexp_validator (r, e: STRING)
			-- Initialize with specified regular expression and error message which will be displayed on validation failure
		do
			make (e)
			regexp_string := r
			create regexp
		end

feature -- Implementation

	is_valid (input: STRING): BOOLEAN
		do
				--Only compile when used
			if not regexp.is_compiled then
				regexp.compile (regexp_string)
			end
			Result := regexp.matches (input)
		end

feature -- State

	state: JSON_OBJECT
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json ("WSF_REGEXP_VALIDATOR"), "name")
			Result.put (create {JSON_STRING}.make_json (regexp_string), "expression")
			Result.put (create {JSON_STRING}.make_json (error), "error")
		end

feature -- Properties

	regexp_string: STRING

	regexp: REGULAR_EXPRESSION

end
