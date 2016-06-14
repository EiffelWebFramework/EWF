note
	description: "[
			Component to launch the service using the default connector

				Eiffel Web httpd for this class


				The httpd default connector support options:
					port: numeric such as 8099 (or equivalent string as "8099")
					base: base_url (very specific to standalone server)
					verbose: to display verbose output, useful for standalone connector
					force_single_threaded: use only one thread, useful for standalone connector

			check WSF_SERVICE_LAUNCHER for more documentation
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STANDALONE_SERVICE_LAUNCHER [G -> WSF_EXECUTION create make end]

inherit
	WSF_SERVICE_LAUNCHER [G]
		redefine
			launchable
		end

create
	make,
	make_and_launch

feature {NONE} -- Initialization

	initialize
		local
			conn: like connector
		do
			create on_launched_actions
			create on_stopped_actions

			port_number := 80 --| Default, but quite often, this port is already used ...
			keep_alive_timeout := 5_000 -- 5 seconds.
			base_url := ""

			if attached options as opts then
				if attached {READABLE_STRING_GENERAL} opts.option ("server_name") as l_server_name then
					server_name := l_server_name.to_string_8
				end
				if attached {READABLE_STRING_GENERAL} opts.option ("base") as l_base_str then
					base_url := l_base_str.as_string_8
				end
				verbose := opts.option_boolean_value ("verbose", verbose)
				port_number := opts.option_integer_value ("port", port_number)

				if opts.option_boolean_value ("force_single_threaded", single_threaded) then
					force_single_threaded
				end
				max_concurrent_connections := opts.option_integer_value ("max_concurrent_connections", max_concurrent_connections)
				keep_alive_timeout := opts.option_integer_value ("keep_alive_timeout", keep_alive_timeout)
			end

			create conn.make
			connector := conn
			conn.on_launched_actions.extend (agent on_launched)
			conn.set_base (base_url)

			update_configuration (conn.configuration)
		end

	force_single_threaded
			-- Set `single_threaded' to True.
		do
			max_concurrent_connections := 1
 		end		

feature -- Execution

	update_configuration (cfg: like connector.configuration)
		do
			cfg.set_is_verbose (verbose)
			if attached server_name as l_server_name then
				cfg.set_http_server_name (l_server_name)
			end
			cfg.http_server_port := port_number
			cfg.set_max_concurrent_connections (max_concurrent_connections)
			cfg.set_keep_alive_timeout (keep_alive_timeout)
--			conn.update_configuration (cfg)
		end

	launch
			-- <Precursor/>
			-- using `port_number', `base_url', `verbose' and `single_threaded'
		local
			conn: like connector
		do
			conn := connector
			conn.set_base (base_url)
			debug ("ew_standalone")
				if verbose then
					io.error.put_string ("Launching standalone web server on port " + port_number.out)
					if attached server_name as l_name then
						io.error.put_string ("%N http://" + l_name + ":" + port_number.out + "/" + base_url + "%N")
					else
						io.error.put_string ("%N http://localhost:" + port_number.out + "/" + base_url + "%N")
					end
				end
			end
			update_configuration (conn.configuration)
			conn.launch
		end

feature -- Callback

	on_launched_actions: ACTION_SEQUENCE [TUPLE [WGI_STANDALONE_CONNECTOR [G]]]
			-- Actions triggered when launched

	on_stopped_actions: ACTION_SEQUENCE [TUPLE [WGI_STANDALONE_CONNECTOR [G]]]
			-- Actions triggered when stopped

feature {NONE} -- Implementation

	on_launched (conn: WGI_STANDALONE_CONNECTOR [G])
		do
			on_launched_actions.call ([conn])
		end

	port_number: INTEGER

	server_name: detachable READABLE_STRING_8

	base_url: READABLE_STRING_8

	verbose: BOOLEAN

	single_threaded: BOOLEAN
		do
			Result := max_concurrent_connections = 0
		end

	max_concurrent_connections: INTEGER

	keep_alive_timeout: INTEGER	

feature -- Status report

	connector: WGI_STANDALONE_CONNECTOR [G]
			-- Default connector

	launchable: BOOLEAN
		do
			Result := Precursor and port_number >= 0
		end

;note
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
