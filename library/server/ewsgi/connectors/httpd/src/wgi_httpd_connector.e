note
	description: "Summary description for {WGI_HTTPD_CONNECTOR}."
	author: ""
	todo: "[
		Check if server and configuration has to be 'separate' ? 
		currently yes, due to WGI_REQUEST.wgi_connector setting.
		But we may get rid of this one...
		See `{WGI_REQUEST}.wgi_connector' and `{WSF_REQUEST}.wgi_connector' ...
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_HTTPD_CONNECTOR [G -> WGI_EXECUTION create make end]

inherit
	WGI_CONNECTOR

create
	make,
	make_with_base

feature {NONE} -- Initialization

	make
		local
			fac: separate WGI_HTTPD_REQUEST_HANDLER_FACTORY [G]
		do
				-- Callbacks
			create on_launched_actions
			create on_stopped_actions

				-- Server
			create fac
			create server.make (fac)
			configuration := server_configuration (server)

			set_factory_connector (Current, fac)
		end

	make_with_base (a_base: like base)
		require
			a_base_starts_with_slash: (a_base /= Void and then not a_base.is_empty) implies a_base.starts_with ("/")
		do
			make
			set_base (a_base)
		end

	set_factory_connector (conn: detachable separate WGI_HTTPD_CONNECTOR [G]; fac: separate WGI_HTTPD_REQUEST_HANDLER_FACTORY [G])
		do
			fac.set_connector (conn)
		end

feature -- Access

	name: STRING_8 = "httpd"
			-- Name of Current connector

	version: STRING_8 = "0.1"
			-- Version of Current connector

feature -- Access

	server: separate HTTPD_SERVER

	configuration: separate HTTPD_CONFIGURATION

	server_configuration (a_server: like server): like configuration
		do
			Result := a_server.configuration
		end

feature -- Access

	base: detachable READABLE_STRING_8
			-- Root url base

feature -- Status report

	launched: BOOLEAN
			-- Server launched and listening on `port'

	port: INTEGER
			-- Listening port.
			--| 0: not launched			

feature -- Callbacks

	on_launched_actions: ACTION_SEQUENCE [TUPLE [WGI_CONNECTOR]]
			-- Actions triggered when launched

	on_stopped_actions: ACTION_SEQUENCE [TUPLE [WGI_CONNECTOR]]
			-- Actions triggered when stopped

feature -- Element change

	on_launched (a_port: INTEGER)
			-- Server launched
		do
			launched := True
			port := a_port
			on_launched_actions.call ([Current])
		end

	on_stopped
			-- Server stopped
		do
			on_stopped_actions.call ([Current])
			launched := False
			port := 0
		end

feature -- Element change

	set_base (b: like base)
		require
			b_starts_with_slash: (b /= Void and then not b.is_empty) implies b.starts_with ("/")
		do
			base := b
		ensure
			valid_base: (attached base as l_base and then not l_base.is_empty) implies l_base.starts_with ("/")
		end

	set_port_number (a_port_number: INTEGER)
		require
			a_port_number_positive_or_zero: a_port_number >= 0
		do
			set_port_on_configuration (a_port_number, configuration)
		end

	set_max_concurrent_connections (nb: INTEGER)
		require
			nb_positive_or_zero: nb >= 0
		do
			set_max_concurrent_connections_on_configuration (nb, configuration)
		end

	set_is_verbose (b: BOOLEAN)
		do
			set_is_verbose_on_configuration (b, configuration)
		end

feature {NONE} -- Implementation

	set_port_on_configuration (a_port_number: INTEGER; cfg: like configuration)
		do
			cfg.set_http_server_port (a_port_number)
		end

	set_max_concurrent_connections_on_configuration (nb: INTEGER; cfg: like configuration)
		do
			cfg.set_max_concurrent_connections (nb)
		end

	set_is_verbose_on_configuration (b: BOOLEAN; cfg: like configuration)
		do
			cfg.set_is_verbose (b)
		end

feature -- Server

	launch
		do
			launched := False
			port := 0
			launch_server (server)
		end

	configure_server (a_configuration: like configuration)
		do
			if a_configuration.is_verbose then
				if attached base as l_base then
					io.error.put_string ("Base=" + l_base + "%N")
				end
			end
		end

	launch_server (a_server: like server)
		do
			configure_server (a_server.configuration)
			a_server.launch
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

