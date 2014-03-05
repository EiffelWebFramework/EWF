note
	description: "[
		Base validation class which can be added to the WSF_FORM_ELEMENT_CONTROL
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALIDATOR [G]

feature {NONE} -- Initialization

	make (e: STRING_32)
			-- Initialize with specified error message to be displayed on validation failure
		do
			error := e
		end

feature -- Access

	state: WSF_JSON_OBJECT
			-- JSON state of this validator
		do
			create Result.make
			Result.put_string (generator, "name")
			Result.put_string (error, "error")
		end

	is_valid (input: G): BOOLEAN
			-- Perform validation on given input and tell whether validation was successful or not
		deferred
		end

feature -- Properties

	error: STRING_32

end
