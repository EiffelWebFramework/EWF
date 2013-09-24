note
	description: "Summary description for {WSF_VALUE_CONTROL}."
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

end
