note
	description: "Summary description for {APP_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	APP_APPLICATION

inherit
	REST_APPLICATION [APP_REQUEST_HANDLER, APP_REQUEST_HANDLER_CONTEXT]
		redefine
			router
		end

feature {NONE} -- Router

	router: APP_REQUEST_ROUTER

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
