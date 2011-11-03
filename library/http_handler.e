note
	description: "Summary description for {HTTP_CONNECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTP_HANDLER

inherit
	THREAD

	HTTP_CONSTANTS

feature {NONE} -- Initialization

	make (a_main_server: like main_server; a_name: STRING)
			-- Creates a {HTTP_HANDLER}, assigns the main_server and initialize various values
			--
			-- `a_main_server': The main server object
			-- `a_name': The name of this module
		require
			a_main_server_attached: a_main_server /= Void
			a_name_attached: a_name /= Void
		do
			main_server := a_main_server
			is_stop_requested := False
		ensure
			main_server_set: a_main_server ~ main_server
		end

feature -- Inherited Features

	execute
			-- <Precursor>
			-- Creates a socket and connects to the http server.
		local
			l_http_socket: detachable TCP_STREAM_SOCKET
			l_http_port: INTEGER
		do
			launched := False
			port := 0
			is_stop_requested := False
			l_http_port := main_server_configuration.http_server_port
			create l_http_socket.make_server_by_port (l_http_port)
			if not l_http_socket.is_bound then
				if is_verbose then
					print ("Socket could not be bound on port " + l_http_port.out )
				end
			else
				l_http_port := l_http_socket.port
				port := l_http_port
				from
					l_http_socket.listen (main_server_configuration.max_tcp_clients)
					if is_verbose then
						print ("%NHTTP Connection Server ready on port " + l_http_port.out +" : http://localhost:" + l_http_port.out + "/%N")
					end
					launched := True
				until
					is_stop_requested
				loop
					l_http_socket.accept
					if not is_stop_requested then
						if attached l_http_socket.accepted as l_thread_http_socket then
								--| FIXME jfiat [2011/11/03] : should launch a new thread to handle this connection
								--| also handle permanent connection...?
							receive_message_and_send_reply (l_thread_http_socket)
							l_thread_http_socket.cleanup
							check
								socket_closed: l_thread_http_socket.is_closed
							end
						end
					end
					is_stop_requested := main_server.stop_requested
				end
				l_http_socket.cleanup
				check
					socket_is_closed: l_http_socket.is_closed
				end
			end
			launched := False
			if is_verbose then
				print ("HTTP Connection Server ends.")
			end
		rescue
			print ("HTTP Connection Server shutdown due to exception. Please relaunch manually.")

			if attached l_http_socket as ll_http_socket then
				ll_http_socket.cleanup
				check
					socket_is_closed: ll_http_socket.is_closed
				end
			end
			launched := False
			is_stop_requested := True
			retry
		end

feature -- Access
	
	is_verbose: BOOLEAN
			-- Is verbose for output messages.
		do
			Result := main_server_configuration.is_verbose
		end

	is_stop_requested: BOOLEAN
			-- Set true to stop accept loop

	launched: BOOLEAN
			-- Server launched and listening on `port'

	port: INTEGER
			-- Listening port.
			--| 0: not launched

feature {NONE} -- Access

	main_server: HTTP_SERVER
			-- The main server object

	main_server_configuration: HTTP_SERVER_CONFIGURATION
			-- The main server's configuration
		do
			Result := main_server.configuration
		end

feature -- Status setting

	shutdown
			-- Stops the thread
		do
			is_stop_requested := True
		end

feature -- Execution

	receive_message_and_send_reply (client_socket: TCP_STREAM_SOCKET)
		require
			socket_attached: client_socket /= Void
--			socket_valid: client_socket.is_open_read and then client_socket.is_open_write
			a_http_socket: not client_socket.is_closed
		deferred
		end

invariant
	main_server_attached: main_server /= Void

note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
