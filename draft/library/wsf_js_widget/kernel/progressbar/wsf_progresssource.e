note
	description: "Summary description for {WSF_PROGRESSSOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PROGRESSSOURCE

feature -- Specification

	progress: INTEGER
			-- Current value of progress between 0 and 100 of this progresssource
		deferred
		end

end
