note
	description: "Summary description for {DEFAULT_APPLICATION}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFAULT_APPLICATION

inherit
	WSF_APPLICATION

feature {NONE} -- Initialization

	make_and_launch
		local
			app: NINO_APPLICATION
		do
			port_number := 8080
			base_url := ""
			debug ("nino")
				print ("Example: start a Nino web server on port " + port_number.out +
					 ", %Nand reply Hello World for any request such as http://localhost:" + port_number.out + "/" + base_url + "%N")
			end
			create app.make_custom (agent wgi_execute, base_url)
			app.listen (port_number)
		end

	port_number: INTEGER

	base_url: STRING

invariant
	port_number_valid: port_number > 0
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
