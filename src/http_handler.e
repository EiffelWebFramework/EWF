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
			is_stop_requested := False
			l_http_port := main_server_configuration.http_server_port
			create l_http_socket.make_server_by_port (l_http_port)
			if not l_http_socket.is_bound then
				print ("Socket could not be bound on port " + l_http_port.out )
			else
				from
					l_http_socket.listen (main_server_configuration.max_tcp_clients)
					print ("%NHTTP Connection Server ready on port " + l_http_port.out +"%N")
				until
					is_stop_requested
				loop
					l_http_socket.accept
					if not is_stop_requested then
						if attached l_http_socket.accepted as l_thread_http_socket then
							receive_message_and_send_reply (l_thread_http_socket)
							l_thread_http_socket.cleanup
							check
								socket_closed: l_thread_http_socket.is_closed
							end
						end
					end
				end
				l_http_socket.cleanup
				check
					socket_is_closed: l_http_socket.is_closed
				end
			end
			print ("HTTP Connection Server ends.")
		rescue
			print ("HTTP Connection Server shutdown due to exception. Please relaunch manually.")

			if attached l_http_socket as ll_http_socket then
				ll_http_socket.cleanup
				check
					socket_is_closed: ll_http_socket.is_closed
				end
			end
			is_stop_requested := True
			retry
		end

feature -- Access

	is_stop_requested: BOOLEAN
			-- Set true to stop accept loop

feature {NONE} -- Access

	main_server: HTTP_SERVER
			-- The main server object

	main_server_configuration: HTTP_SERVER_CONFIGURATION
			-- The main server's configuration
		do
			Result := main_server.configuration
		end

	Max_fragments: INTEGER = 1000
			-- Defines the maximum number of fragments that can be received

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
			a_http_socket:client_socket /= Void and then not client_socket.is_closed
		deferred
		end

invariant
	main_server_attached: main_server /= Void

end
