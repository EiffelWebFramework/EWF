note
	description: "Summary description for {WSF_AUTOCOMPLETION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_AUTOCOMPLETION

feature -- Access

	autocompletion (input: STRING_32): JSON_ARRAY
			-- JSON array of suggestions that fit the specific input
		deferred
		end

	template: detachable STRING_32
			-- Customizable template

end
