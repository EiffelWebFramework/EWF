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

feature -- Request processing

	process_request (a_uri: STRING; a_method: STRING; a_headers_map: HASH_TABLE [STRING, STRING]; a_headers_text: STRING; a_input: HTTP_INPUT_STREAM; a_output: HTTP_OUTPUT_STREAM)
			-- Process request ...
		require
			a_uri_attached: a_uri /= Void
			a_method_attached: a_method /= Void
			a_headers_text_attached: a_headers_text /= Void
			a_input_attached: a_input /= Void
			a_output_attached: a_output /= Void
		do
			if a_method.is_equal (Get) then
				execute_get_request (a_uri, a_headers_map, a_headers_text, a_input, a_output)
			elseif a_method.is_equal (Post) then
				execute_post_request (a_uri, a_headers_map, a_headers_text, a_input, a_output)
			elseif a_method.is_equal (Put) then
			elseif a_method.is_equal (Options) then
			elseif a_method.is_equal (Head) then
			elseif a_method.is_equal (Delete) then
			elseif a_method.is_equal (Trace) then
			elseif a_method.is_equal (Connect) then
			else
				debug
					print ("Method [" + a_method + "] not supported")
				end
			end
		end

	execute_get_request (a_uri: STRING; a_headers_map: HASH_TABLE [STRING, STRING]; a_headers_text: STRING; a_input: HTTP_INPUT_STREAM; a_output: HTTP_OUTPUT_STREAM)
		local
			l_http_request : HTTP_REQUEST_HANDLER
		do
			create {GET_REQUEST_HANDLER} l_http_request.make (a_input, a_output)
			l_http_request.set_uri (a_uri)
			l_http_request.process
--			client_socket.put_string (l_http_request.answer.reply_header + l_http_request.answer.reply_text)
		end

	execute_post_request (a_uri: STRING; a_headers_map: HASH_TABLE [STRING, STRING]; a_headers_text: STRING; a_input: HTTP_INPUT_STREAM; a_output: HTTP_OUTPUT_STREAM)
		local
			l_http_request : HTTP_REQUEST_HANDLER
		do
			check not_yet_implemented: False end
			create {POST_REQUEST_HANDLER} l_http_request.make (a_input, a_output)
			l_http_request.set_uri (a_uri)
			l_http_request.process
--			client_socket.put_string (l_http_request.answer.reply_header + l_http_request.answer.reply_text)
		end

feature -- Access

	is_stop_requested: BOOLEAN
			-- Set true to stop accept loop

feature {NONE} -- Access

	request_header_map : HASH_TABLE [STRING,STRING]
			-- Contains key:value of the header

	main_server: HTTP_SERVER
			-- The main server object

	main_server_configuration: HTTP_SERVER_CONFIGURATION
			-- The main server's configuration
		do
			Result := main_server.configuration
		end

	current_request_message: STRING
			-- Stores the current request message received from http server

	Max_fragments: INTEGER = 1000
			-- Defines the maximum number of fragments that can be received

	method: STRING
			-- http verb

	uri: STRING
			--  http endpoint		

	version: detachable STRING
			--  http_version
			--| unused for now

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
			l_headers_text: detachable STRING
			l_input: HTTP_INPUT_STREAM
			l_output: HTTP_OUTPUT_STREAM
		do
			parse_request_line (client_socket)
            l_headers_text := receive_message_internal (client_socket)

			create l_input.make (client_socket)
			create l_output.make (client_socket)
			process_request (uri, method, request_header_map, l_headers_text, l_input, l_output)
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
                pos := line.index_of (':',1)
               	request_header_map.put (line.substring (pos + 1, line.count), line.substring (1,pos-1))
                Result.append (line)
                Result.append_character ('%N')
                if not line.is_equal("%R") and socket.socket_ok then
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
