note
	description: "Summary description for {WSF_VALIDATABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALIDATABLE

feature -- Specification

	validate
			-- Perform validation
		deferred
		end

	is_valid: BOOLEAN
			-- Result of last validation
		deferred
		end

end
