note
	description: "Summary description for {WSF_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALIDATOR [G]

feature {NONE} -- Initialization

	make (e: STRING)
			-- Initialize with specified error message to be displayed on validation failure
		do
			error := e
		end

feature -- Access

	state: JSON_OBJECT
			-- JSON state of this validator
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (generator), "name")
			Result.put (create {JSON_STRING}.make_json (error), "error")
		end

	is_valid (input: G): BOOLEAN
			-- Perform validation on given input and tell whether validation was successful or not
		deferred
		end

feature -- Properties

	error: STRING

end
