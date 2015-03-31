note
	description: "Summary description for {HTTPD_SERVER_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTPD_SERVER_OBSERVER

feature -- Event

	on_launched (a_port: INTEGER)
		deferred
		end

	on_stopped
		deferred
		end

	on_terminated
		deferred
		end

end
