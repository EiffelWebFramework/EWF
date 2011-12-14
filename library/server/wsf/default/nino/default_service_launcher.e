note
	description: "[
			Component to launch the service using the default connector

			which is Eiffel Web Nino for this class

			How-to:

				s: DEFAULT_SERVICE_LAUNCHER
				create s.make_and_launch (agent execute)

				execute (req: WSF_REQUEST; res: WSF_RESPONSE)
					do
						-- ...
					end
					
				You can also provide specific options that might be relevant
				only for specific connectors such as
				
				create s.make_and_launch_and_options (agent execute, <<["port", 8099]>>)
				The Nino default connector support:
					port: numeric such as 8099 (or equivalent string as "8099")
					base: base_url (very specific to standalone server)
					verbose: to display verbose output, useful for Nino
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_SERVICE_LAUNCHER

inherit
	WSF_SERVICE

create
	make_and_launch,
	make_and_launch_with_options

feature {NONE} -- Initialization

	make_and_launch (a_action: like action)
		do
			action := a_action
			launch (80, "", False)
		end

	make_and_launch_with_options (a_action: like action; a_options: ARRAY [detachable TUPLE [name: READABLE_STRING_GENERAL; value: detachable ANY]])
		local
			port_number: INTEGER
			base_url: STRING
			verbose: BOOLEAN
			l_name: READABLE_STRING_GENERAL
		do
			action := a_action
			port_number := 80 --| Default, but quite often, this port is already used ...
			base_url := ""
			across
				a_options as opt
			loop
				if attached opt.item as l_opt_item then
					l_name := l_opt_item.name
					if l_name.same_string ("port") then
						if attached {INTEGER} l_opt_item.value as l_port then
							port_number := l_port
						elseif
							attached {READABLE_STRING_GENERAL} l_opt_item.value as l_port_str and then
							l_port_str.is_integer
						then
							port_number := l_port_str.as_string_8.to_integer
						end
					elseif l_name.same_string ("base") then
						if attached {READABLE_STRING_GENERAL} l_opt_item.value as l_base_str then
							base_url := l_base_str.as_string_8
						end
					elseif l_name.same_string ("verbose") then
						if attached {BOOLEAN} l_opt_item.value as l_verbose then
							verbose := l_verbose
						elseif attached {READABLE_STRING_GENERAL} l_opt_item.value as l_verbose_str then
							verbose := l_verbose_str.as_lower.same_string ("true")
						end
					end
				end
			end
			launch (port_number, base_url, verbose)
		end

	launch (a_port: INTEGER; a_base: STRING; a_verbose: BOOLEAN)
			-- Launch service with `a_port', `a_base' and `a_verbose' value
		require
			a_port_valid: a_port > 0
		local
			app: NINO_SERVICE
		do
			create app.make_custom (agent wgi_execute, a_base)
			app.set_is_verbose (a_verbose)
			debug ("nino")
				if a_verbose then
					print ("Example: start a Nino web server on port " + a_port.out +
						 ", %Nand reply Hello World for any request such as http://localhost:" + a_port.out + "/" + a_base + "%N")
				end
			end
			app.listen (a_port)
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
