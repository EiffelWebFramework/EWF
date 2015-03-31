note
	description: "Summary description for {WGI_STANDALONE_SERVER_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_STANDALONE_SERVER_OBSERVER

inherit
	HTTPD_SERVER_OBSERVER

feature -- Access

	started: BOOLEAN

	stopped: BOOLEAN

	terminated: BOOLEAN

	port: INTEGER

feature -- Event

	on_launched (a_port: INTEGER)
		do
			started := True
			port := a_port
		end

	on_stopped
		do
			stopped := True
		end

	on_terminated
		do
			port := 0
			terminated := True
		end


note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
