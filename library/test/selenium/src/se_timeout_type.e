note
	description: "Summary description for {SE_TIMEOUT_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_TIMEOUT_TYPE

create
	make,
	make_empty

feature -- Initialization
	make (a_type : STRING_32; a_ms : INTEGER_32)
		do
			set_type (a_type)
			set_ms (a_ms)
		end

	make_empty
		do

		end
		
feature -- Access
	type : detachable STRING_32
		-- The type of operation to set the timeout for.
		-- Valid values are: "script" for script timeouts,
		--					 "implicit" for modifying the implicit wait timeout and
		--					 "page load" for setting a page load timeout.
	ms : INTEGER_32
		-- The amount of time, in milliseconds, that time-limited commands are permitted to run.

feature -- Change Element
	set_type (a_type : STRING_32)
		do
			type := a_type
		end

	set_ms (a_ms : INTEGER_32)
		do
			ms := a_ms
		end
end
