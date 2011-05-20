note
	description: "Summary description for {HTTP_CONNECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CONNECTION_HANDLER

inherit

	THREAD
	HTTP_CONSTANTS
create
	make

feature {NONE} -- Initialization

	make (a_main_server: like main_server; a_name: STRING)
			-- Creates a {HTTP_CONNECTION_HANDLER}, assigns the main_server and sets the current_request_message to empty.
			--
			-- `a_main_server': The main server object
			-- `a_name': The name of this module
		require
			a_main_server_attached: a_main_server /= Void
			a_name_attached: a_name /= Void
		do
			main_server := a_main_server
			create current_request_message.make_empty
			create method.make_empty
			create uri.make_empty
			create request_header_map.make (10)
			is_stop_requested := False
		ensure
			main_server_set: a_main_server ~ main_server
			current_request_message_attached: current_request_message /= Void
		end

feature -- Inherited Features

	execute
			-- <Precursor>
			-- Creates a socket and connects to the http server.
		local
			l_http_socket: detachable TCP_STREAM_SOCKET
		do
			is_stop_requested := False
			create l_http_socket.make_server_by_port ({HTTP_CONSTANTS}.Http_server_port)
			if not l_http_socket.is_bound then
				print ("Socket could not be bound on port " + {HTTP_CONSTANTS}.Http_server_port.out )
			else
				from
					l_http_socket.listen ({HTTP_CONSTANTS}.Max_tcp_clients)
					print ("%NHTTP Connection Server ready on port " + {HTTP_CONSTANTS}.Http_server_port.out +"%N")
				until
					is_stop_requested
				loop
					l_http_socket.accept
					if not is_stop_requested then
						if attached l_http_socket.accepted as l_thread_http_socket then
							receive_message_and_send_replay (l_thread_http_socket)
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

	request_header_map : HASH_TABLE [STRING,STRING]
			-- Containts key value of the header

	main_server: HTTP_SERVER
			-- The main server object

	current_request_message: STRING
			-- Stores the current request message received from http server

	Max_fragments: INTEGER = 1000
			-- Defines the maximum number of fragments that can be received

	method :  STRING
		-- http verb

	uri   :	 STRING
		--  http endpoint		

	version : STRING
		--  http_version
feature -- Status setting

	shutdown
			-- Stops the thread
		do
			is_stop_requested := True
		end

feature {NONE} -- Implementation



	read_string_from_socket (a_socket: TCP_STREAM_SOCKET; a_n: NATURAL): STRING
			-- Reads characters from the socket and concatenates them to a string
			--
			-- `a_socket': The socket to read from
			-- `a_n': The number of characters to read
			-- `Result': The created string
		require
			socket_is_open: not a_socket.is_closed
		local
			l_read_size: INTEGER
			l_buf: detachable STRING
		do
			create Result.make (a_n.as_integer_32)
			from
				l_read_size := 0
				Result := ""
				l_buf := ""
			until
				l_buf.is_equal ("%R")
			loop
				a_socket.read_line_thread_aware
				l_buf := a_socket.last_string
				if l_buf /= Void then
					Result.append (l_buf)
				end
				if l_buf.is_equal ("%R") then
					a_socket.set_nodelay
					a_socket.put_string ("HTTP/1.1 100 Continue%/13/%/10/%/13/%/10/")
					a_socket.close_socket
				end

				l_read_size := Result.count
			end
		ensure
			Result_attached: Result /= Void
		end



feature -- New implementation


	parse_http_request_line (line: STRING)
		require
			line /= Void
		local
			pos, next_pos: INTEGER
		do
			print ("%N parse http request line:%N" + line)
			-- parse (this should be done by a lexer)
			pos := line.index_of (' ', 1)
			method := line.substring (1, pos - 1)
			next_pos := line.index_of (' ', pos+1)
			uri := line.substring (pos+1, next_pos-1)
		ensure
			not_void_method: method /= Void
		end

feature -- New Implementation
	receive_message_and_send_replay (client_socket: TCP_STREAM_SOCKET)
		require
			socket_attached: client_socket /= Void
--			socket_valid: client_socket.is_open_read and then client_socket.is_open_write
			a_http_socket:client_socket /= Void and then not client_socket.is_closed
		local
			message: detachable STRING
			l_http_request : HTTP_REQUEST_HANDLER
		do
			parse_request_line (client_socket)
            message := receive_message_internal (client_socket)
			if method.is_equal (Get) then
				create {GET_REQUEST_HANDLER} l_http_request
				l_http_request.set_uri (uri)
				l_http_request.process
--				client_socket.send_message (l_http_request.answer.reply_header  + l_http_request.answer.reply_text)
				client_socket.put_string (l_http_request.answer.reply_header  + l_http_request.answer.reply_text)
			elseif method.is_equal (Post) then
			elseif method.is_equal (Put) then
			elseif method.is_equal (Options) then
			elseif method.is_equal (Head) then
			elseif method.is_equal (Delete) then
			elseif method.is_equal (Trace) then
			elseif method.is_equal (Connect) then
			else
				debug
					print ("Method not supported")
				end
			end
		end


	parse_request_line (socket: NETWORK_STREAM_SOCKET)
        require
            socket: socket /= Void and then not socket.is_closed
        do
        	socket.read_line
			parse_request_line_internal (socket.last_string)
		end

	receive_message_internal (socket: TCP_STREAM_SOCKET) : STRING
        require
            socket: socket /= Void and then not socket.is_closed
        local
        	end_of_stream : BOOLEAN
        	pos : INTEGER
        	line : STRING
        do
            from
                socket.read_line_thread_aware
                Result := ""
            until
                end_of_stream
            loop
                line := socket.last_string
                print ("%N" +line+ "%N")
                pos := line.index_of(':',1)
               	request_header_map.put (line.substring (pos + 1, line.count), line.substring (1,pos-1))
                Result.append(socket.last_string)
                if not socket.last_string.is_equal("%R") and socket.socket_ok  then
                	socket.read_line_thread_aware
        		else
        			end_of_stream := True
        		end
        	end
		end

	parse_request_line_internal (line: STRING)
		require
			line /= Void
		local
			pos, next_pos: INTEGER
		do
			print ("%N parse request line:%N" + line)
			pos := line.index_of (' ', 1)
			method := line.substring (1, pos - 1)
			next_pos := line.index_of (' ', pos+1)
			uri := line.substring (pos+1, next_pos-1)
			version := line.substring (next_pos + 1, line.count)
		ensure
			not_void_method: method /= Void
		end

invariant
	main_server_attached: main_server /= Void
	current_request_message_attached: current_request_message /= Void

end
