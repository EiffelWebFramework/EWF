note
	description: "Summary description for {WGI_CONNECTOR}."
	specification: "EWSGI/connector specification https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki/EWSGI-specification"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_CONNECTOR

feature {NONE} -- Initialization

	make (a_app: like application)
		do
			application := a_app
			initialize
		end

	initialize
			-- Initialize connector
		do
		end

feature {NONE} -- Access

	application: WGI_APPLICATION
			-- Gateway Application

feature -- Server

	launch
		deferred
		end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
