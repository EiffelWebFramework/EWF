note
	description: "Summary description for {WSF_AUTOCOMPLETION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_AUTOCOMPLETION

feature -- Access

	autocompletion (input: STRING): JSON_ARRAY
			-- JSON array of suggestions that fit the specific input
		deferred
		end

	template: detachable STRING
			-- Customizable template

end
