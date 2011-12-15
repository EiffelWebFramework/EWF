note
	description: "[
			Component to launch the service using the default connector

				Eiffel Web Nino for this class


				The Nino default connector support options:
					port: numeric such as 8099 (or equivalent string as "8099")
					base: base_url (very specific to standalone server)
					verbose: to display verbose output, useful for Nino
					force_single_threaded: use only one thread, useful for Nino

			check DEFAULT_SERVICE_LAUNCHER_I for more documentation
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_SERVICE_LAUNCHER

inherit
	DEFAULT_SERVICE_LAUNCHER_I
		redefine
			launchable
		end

create
	make,
	make_and_launch,
	make_and_launch_with_options

feature {NONE} -- Initialization

	initialize
		local
			l_name: detachable READABLE_STRING_GENERAL
		do
			port_number := 80 --| Default, but quite often, this port is already used ...
			base_url := ""
			if attached options as opts then
				across
					opts as opt
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
						elseif l_name.same_string ("force_single_threaded") then
							if attached {BOOLEAN} l_opt_item.value as l_single_threaded then
								single_threaded := l_single_threaded
							elseif attached {READABLE_STRING_GENERAL} l_opt_item.value as l_single_threaded_str then
								single_threaded := l_single_threaded_str.as_lower.same_string ("true")
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
			end
			create connector.make (Current)
			if attached connector as conn then
				conn.set_base (base_url)
				if single_threaded then
					conn.configuration.set_force_single_threaded (True)
				end
				conn.configuration.set_is_verbose (verbose)
			end
		end

feature -- Execution

	launch
			-- <Precursor/>
			-- using `port_number', `base_url', `verbose' and `single_threaded'
		do
			if attached connector as conn then
				conn.set_base (base_url)
				if single_threaded then
					conn.configuration.set_force_single_threaded (True)
				end
				conn.configuration.set_is_verbose (verbose)
				debug ("nino")
					if verbose then
						print ("Example: start a Nino web server on port " + port_number.out +
							 ", %Nand reply Hello World for any request such as http://localhost:" + port_number.out + "/" + base_url + "%N")
					end
				end
				conn.configuration.http_server_port := port_number
				conn.launch
			end
		end

feature {NONE} -- Implementation

	port_number: INTEGER

	base_url: READABLE_STRING_8

	verbose: BOOLEAN

	single_threaded: BOOLEAN

feature -- Status report

	connector: detachable WGI_NINO_CONNECTOR
			-- Default connector

	launchable: BOOLEAN
		do
			Result := Precursor and port_number > 0
		end

;note
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
