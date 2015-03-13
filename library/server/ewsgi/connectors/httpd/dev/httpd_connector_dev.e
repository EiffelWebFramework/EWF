note
	description: "[
			Objects that ...
		]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	HTTPD_CONNECTOR_DEV

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		local
			server: HTTPD_SERVER
			fac: separate WSF_HTTPD_REQUEST_HANDLER_FACTORY [APP_WSF_EXECUTION]
		do
			print ("Hello%N")
			create fac
			create server.make (fac)
			server.configuration.set_http_server_port (9090)
			server.launch
		end

feature -- Status

feature -- Access

feature -- Change

feature {NONE} -- Implementation

invariant
--	invariant_clause: True

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
