note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HELLO_WORLD

inherit
	GW_APPLICATION_IMP

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		local
			conn: detachable GW_CONNECTOR
			nino_conn: GW_NINO_CONNECTOR
		do
			if is_nino then
				create nino_conn.make_with_base (Current, "/hello_world")
				if attached nino_conn.server.server_configuration as cfg then
					cfg.http_server_port := 8080
					cfg.force_single_threaded := True
				end
				conn := nino_conn
			elseif is_cgi then
				create {GW_CGI_CONNECTOR} conn.make (Current)
			elseif is_libfcgi then
				create {GW_LIBFCGI_CONNECTOR} conn.make (Current)
			else
				io.error.put_string ("Unsupported connector")
			end
			if conn /= Void then
				conn.launch
			end
		end

	is_nino: BOOLEAN = True
	is_cgi: BOOLEAN = False
	is_libfcgi: BOOLEAN = False

feature -- Execution

	execute (ctx: GW_REQUEST_CONTEXT)
			-- Execute the request
		do
			ctx.output.put_string ("Hello World!%N")
			if attached ctx.execution_variable ("REQUEST_COUNT") as rq_count then
				ctx.output.put_string ("Request #" + rq_count + "%N")
			end
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
