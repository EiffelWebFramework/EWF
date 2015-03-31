note
	description: "Summary description for {HTTPD_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTPD_CONTROLLER

feature -- Operation

	shutdown
		do
			shutdown_requested := True
		end

	shutdown_requested: BOOLEAN

;note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
