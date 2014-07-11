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
			-- Set `value' to `v'.
		deferred
		end

note
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
