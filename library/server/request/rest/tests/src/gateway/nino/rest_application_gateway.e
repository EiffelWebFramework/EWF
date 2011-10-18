deferred class
	REST_APPLICATION_GATEWAY

inherit
	WSF_APPLICATION

feature -- Access

	build_gateway_and_launch
		local
			app: NINO_APPLICATION
			port_number: INTEGER
			base_url: STRING
		do
			port_number := 8080
			base_url := ""
			debug ("nino")
				print ("Example: start a Nino web server on port " + port_number.out +
					 ", %Nand reply Hello World for any request such as http://localhost:" + port_number.out + "/" + base_url + "%N")
			end
			create app.make_custom (agent execute, base_url)
			app.force_single_threaded

			app.listen (port_number)
		end

	gateway_name: STRING = "NINO"

	exit_with_code (a_code: INTEGER)
		do
			(create {EXCEPTIONS}).die (a_code)
		end

note
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
