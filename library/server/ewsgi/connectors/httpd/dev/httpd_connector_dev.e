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
			conn: WGI_HTTPD_CONNECTOR [APP_WSF_EXECUTION]
		do
			print ("Starting httpd server ...%N")

			create conn.make
			conn.set_port_number (9090)
			conn.set_max_concurrent_connections (100)
			conn.launch
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
