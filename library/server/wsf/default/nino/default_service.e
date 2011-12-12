note
	description: "Summary description for {DEFAULT_SERVICE}."
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_SERVICE

inherit
	WSF_SERVICE

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch (a_action: like action)
		local
			app: NINO_SERVICE
			port_number: INTEGER
			base_url: STRING
		do
			action := a_action
			port_number := 80 --| Default, but quite often, this port is already used ...
			base_url := ""
			debug ("nino")
				print ("Example: start a Nino web server on port " + port_number.out +
					 ", %Nand reply Hello World for any request such as http://localhost:" + port_number.out + "/" + base_url + "%N")
			end
			create app.make_custom (agent wgi_execute, base_url)
			debug ("nino")
				app.set_is_verbose (True)
			end
			app.listen (port_number)
		end

feature -- Execution

	action: PROCEDURE [ANY, TUPLE [WSF_REQUEST, WSF_RESPONSE]]
			-- Action to be executed on request incoming

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			action.call ([req, res])
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
