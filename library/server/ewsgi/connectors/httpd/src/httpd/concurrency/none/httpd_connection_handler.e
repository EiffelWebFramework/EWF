note
	description: "Summary description for {HTTPD_CONNECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTPD_CONNECTION_HANDLER

inherit
	HTTPD_CONNECTION_HANDLER_I

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Access

	is_shutdown_requested: BOOLEAN

	shutdown_requested (a_server: like server): BOOLEAN
		do
			-- FIXME: we should probably remove this possibility, check with EWF if this is needed.
			Result := a_server.controller.shutdown_requested
		end

feature -- Execution

	process_incoming_connection (a_socket: HTTPD_STREAM_SOCKET)
			-- Process incoming connection
			-- note that the precondition matters for scoop synchronization.
		do
			is_shutdown_requested := is_shutdown_requested or shutdown_requested (server)
			if is_shutdown_requested then
				a_socket.cleanup
			elseif attached server.factory.new_handler as h then
				process_connection_handler (h, a_socket)
			else
				check is_not_full: False end
				a_socket.cleanup
			end
			update_is_shutdown_requested
		end

	process_connection_handler (hdl: HTTPD_REQUEST_HANDLER; a_socket: HTTPD_STREAM_SOCKET)
		require
			not hdl.has_error
		do
				--| FIXME jfiat [2011/11/03] : should use a Pool of Threads/Handler to process this connection
				--| also handle permanent connection...?

			hdl.set_client_socket (a_socket)
			if not hdl.has_error then
--				hdl.set_logger (server)
				hdl.execute
			else
				log ("Internal error (set_client_socket failed)")
			end
		rescue
			log ("Releasing handler after exception!")
			hdl.release
			a_socket.cleanup
		end

	update_is_shutdown_requested
		do
			is_shutdown_requested := shutdown_requested (server)
		end

	shutdown
		do
			if not is_shutdown_requested then
				is_shutdown_requested := True
				server.controller.shutdown
			end
		end

feature {HTTPD_SERVER_I} -- Status report

	wait_for_completion
			-- Wait until Current is ready for shutdown
		do
			-- no concurrency, then current task should be done.
		end

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
