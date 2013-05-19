note
	description: "Summary description for {WEB_DRIVER_WAIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_DRIVER_WAIT
inherit
	SHARED_EXECUTION_ENVIRONMENT
create
	make
feature {NONE} -- Initialization
	make ( driver : like web_driver; a_duration : INTEGER_64)
		do
			web_driver := driver
			duration := a_duration
			initialize
		ensure
			driver_set : driver = web_driver
			duration_set : duration = a_duration
		end

feature -- Access
	-- create another feature to accept a predicate
	until_when (condition : PREDICATE[ANY, TUPLE])
		--Evaluate the condition until it's true or timing out .
		local
			found : BOOLEAN
			l_time1, l_time2 : TIME
			l_duration : TIME_DURATION
		do

			create l_time1.make_now
			create l_duration.make_by_seconds (duration.as_integer_32)

			from
				create l_time2.make_now
				if condition.item([]) then
					found := True
				end
			until
				found or
				l_time2.relative_duration (l_time1).fine_seconds_count > l_duration.fine_seconds_count
			loop
				if condition.item([]) then
					found := True
				end
				l_time2.make_now
			end
		end

feature  {NONE}-- Implementation
	web_driver : WEB_DRIVER
	duration : INTEGER_64

	initialize
		do
			web_driver.session_wait (duration)
		end
end
