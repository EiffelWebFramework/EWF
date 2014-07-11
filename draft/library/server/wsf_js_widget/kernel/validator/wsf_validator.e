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
			-- Initialize with specified error message `e' to be displayed on validation failure.
		do
			error := e
		ensure
			error_set: error = e
		end

feature -- Access

	state: WSF_JSON_OBJECT
			-- JSON state of this validator
		do
			create Result.make
			Result.put_string (generator, "name")
			Result.put_string (error, "error")
				-- FIXME: is that correct to always send error message??
		end

	is_valid (a_input: G): BOOLEAN
			-- Perform validation on given input and tell whether validation was successful or not
		deferred
		end

feature -- Properties

	error: STRING_32
			-- The error message if validation fails.

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
