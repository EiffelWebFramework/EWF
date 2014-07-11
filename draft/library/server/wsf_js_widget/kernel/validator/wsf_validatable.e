note
	description: "[
		Defines that control can be validated.
	]"
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
