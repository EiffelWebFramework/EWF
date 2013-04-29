note
	description: "Summary description for {ENUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENUM

feature -- Access

	is_valid_state: BOOLEAN
			-- Is the value of the enumeration valid?
		do
			Result := is_valid_value (value)
		end

	value: INTEGER
			-- The current value of the enumeration.

	set_value (a_value: INTEGER)
		require
			is_valid_value (a_value)
		do
			value := a_value
		end

	is_valid_value (a_value: INTEGER): BOOLEAN
			-- Can `a_value' be used in a `set_value' feature call?
		deferred
		end

invariant
	is_valid_state

end -- class ENUM

