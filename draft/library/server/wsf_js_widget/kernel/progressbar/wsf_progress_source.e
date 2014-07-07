note
	description: "[
			Provides the WSF_PROGRESS_CONTROL with the current progress state.
			Represented by a number between 0 and 100
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PROGRESS_SOURCE

feature -- Specification

	progress: INTEGER
			-- Current value of progress between 0 and 100 of this progresssource
		deferred
		end

end
