note
	description: "Summary description for {WSF_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALIDATOR [G]

feature {NONE}

	make (e: STRING)
		do
			error := e
		end

feature

	state: JSON_OBJECT
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (generator), "name")
			Result.put (create {JSON_STRING}.make_json (error), "error")
		end

	is_valid (input: G): BOOLEAN
		deferred
		end

	error: STRING

end
