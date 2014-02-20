note
	description: "[
		Controls that can store a value inherit from this class.
		Such controls are for example input fields, buttons or checkboxes.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALUE_CONTROL [G]

inherit

	WSF_CONTROL

feature -- Access

	value: G
			-- The current value of this control
		deferred
		end

	set_value (v: G)
		deferred
		end

end
