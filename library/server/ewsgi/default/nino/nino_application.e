note
	description: "Summary description for {NINO_APPLICATION}."
	date: "$Date$"
	revision: "$Revision$"

class
	NINO_APPLICATION

create
	make,
	make_custom

feature {NONE} -- Implementation

	make (a_callback: like {GW_AGENT_APPLICATION}.callback)
			-- Initialize `Current'.
		do
			make_custom (a_callback, Void)
		end

	make_custom (a_callback: like {GW_AGENT_APPLICATION}.callback;	a_base_url: detachable STRING)
			-- Initialize `Current'.
		local
			app: GW_AGENT_APPLICATION
		do
			create app.make (a_callback)
			create connector.make_with_base (app, a_base_url)
		end

	connector: GW_NINO_CONNECTOR
			-- Web server connector

feature -- Status settings

	configuration: HTTP_SERVER_CONFIGURATION
		do
			Result := connector.configuration
		end

	force_single_threaded
			-- Force single threaded behavior
		do
			configuration.force_single_threaded := True
		end

feature -- Server

	listen (a_port: INTEGER)
		do
			configuration.http_server_port := a_port
			connector.launch
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
