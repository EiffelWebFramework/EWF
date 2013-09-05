note
	description: "Summary description for {WSF_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALIDATOR [G]

feature

	validate (input: G): BOOLEAN
		deferred
		end

	error: STRING

end
