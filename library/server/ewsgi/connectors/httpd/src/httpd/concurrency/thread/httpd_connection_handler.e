note
	description: "Summary description for {HTTPD_CONNECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTPD_CONNECTION_HANDLER

inherit
	HTTPD_CONNECTION_HANDLER_I
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		local
			n: INTEGER
		do
			n := max_concurrent_connections (server)
			create pool.make (n.to_natural_32)
		end

feature -- Access

	is_shutdown_requested: BOOLEAN

	max_concurrent_connections (a_server: like server): INTEGER
		do
			Result := a_server.configuration.max_concurrent_connections
		end

feature {HTTPD_SERVER_I} -- Execution

	shutdown
		do
			if not is_shutdown_requested then
				is_shutdown_requested := True
				pool_gracefull_stop (pool)
			end
		end

	pool_gracefull_stop (p: like pool)
		do
			p.terminate
		end

	process_incoming_connection (a_socket: HTTPD_STREAM_SOCKET)
		do
			if is_shutdown_requested then
				a_socket.cleanup
			else
				process_connection_handler (factory.new_handler, a_socket)
			end
		end

	process_connection_handler (hdl: separate HTTPD_REQUEST_HANDLER; a_socket: HTTPD_STREAM_SOCKET)
		require
			not hdl.has_error
		do
			debug ("dbglog")
				dbglog (generator + ".ENTER process_connection_handler {"+ a_socket.descriptor.out +"}")
			end
			if not hdl.has_error then
--				hdl.set_logger (server)
--				hdl.set_client_socket (a_socket)
				pool.add_work (agent hdl.execute (a_socket))
			else
				log ("Internal error (set_client_socket failed)")
			end
			debug ("dbglog")
				dbglog (generator + ".LEAVE process_connection_handler {"+ a_socket.descriptor.out +"}")
			end
		rescue
			log ("Releasing handler after exception!")
			hdl.release (a_socket)
--			hdl.client_socket.cleanup
		end

feature {HTTPD_SERVER_I} -- Status report

	wait_for_completion
			-- Wait until Current is ready for shutdown
		do
			pool.wait_for_completion
		end

feature {NONE} -- Access

	pool: THREAD_POOL [HTTPD_REQUEST_HANDLER] --ANY] --POOLED_THREAD [HTTP_REQUEST_HANDLER]]
			-- Pool of concurrent connection handlers.

invariant
	pool_attached: pool /= Void

note
	copyright: "2011-2014, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
