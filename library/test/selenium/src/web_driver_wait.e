note
	description: "Summary description for {WEB_DRIVER_WAIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_DRIVER_WAIT

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
	wait (condition : STRING)

		local
			found : BOOLEAN
		do
			condition.to_lower
			from
				if attached {STRING_32} web_driver.get_page_tile as l_title then
					l_title.to_lower
					found := l_title.has_substring (condition)
				end
			until
				found
			loop
				if attached web_driver.get_page_tile as l_title then
					l_title.to_lower
					found := l_title.has_substring (condition)

				end
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
