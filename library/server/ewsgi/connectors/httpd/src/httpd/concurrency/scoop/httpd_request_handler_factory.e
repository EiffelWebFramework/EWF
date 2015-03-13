note
	description: "Summary description for {HTTPD_REQUEST_HANDLER_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTPD_REQUEST_HANDLER_FACTORY

inherit
	HTTPD_REQUEST_HANDLER_FACTORY_I

	CONCURRENT_POOL_FACTORY [HTTPD_REQUEST_HANDLER]
		rename
			new_separate_item as new_handler
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
