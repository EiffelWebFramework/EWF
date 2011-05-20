class HTTP_PROTOCOL_HANDLER

inherit

	SHARED_HTTP_REQUEST_HANDLERS

	HTTP_CONSTANTS

create
 		make
feature -- Initialization

	make (socket: NETWORK_STREAM_SOCKET)
		require
			valid_socket: socket /= Void and then socket.is_bound
		local
			done: BOOLEAN
			client_socket: detachable NETWORK_STREAM_SOCKET
		do
			from
				done := False
			until
				done
			loop
				socket.accept
				client_socket := socket.accepted
				if client_socket = Void then
						-- Some error occured, perhaps because of the timeout
						-- We probably should provide some diagnostics here
					io.put_string ("accept result = Void")
					io.put_new_line
				else
					perform_client_communication (client_socket)
				end
			end
		end


feature -- Access
	method 	: STRING
	uri    	: STRING
	version : STRING
	request_header_map : HASH_TABLE [STRING,STRING]
			-- Containts key value of the header

feature -- Implementation

	perform_client_communication (socket: NETWORK_STREAM_SOCKET)
		require
			socket_attached: socket /= Void
			socket_valid: socket.is_open_read and then socket.is_open_write
		local
			done: BOOLEAN
			l_address, l_peer_address: detachable NETWORK_SOCKET_ADDRESS
		do
			l_address := socket.address
			l_peer_address := socket.peer_address
			check
				l_address_attached: l_address /= Void
				l_peer_address_attached: l_peer_address /= Void
			end
			io.put_string ("Accepted client on the listen socket address = "+ l_address.host_address.host_address + " port = " + l_address.port.out +".")
			io.put_new_line
			io.put_string ("%T Accepted client address = " + l_peer_address.host_address.host_address + " , port = " + l_peer_address.port.out)
			io.put_new_line
			create request_header_map.make (20)
			from
				done := False
			until
				done
			loop
				if socket.socket_ok then
					done := receive_message_and_send_replay (socket)
					request_header_map.wipe_out
				else
					done := True
				end
			end
			io.put_string ("Finished processing the client, address = "+ l_peer_address.host_address.host_address + " port = " + l_peer_address.port.out + ".")
			io.put_new_line
		end

	receive_message_and_send_replay (client_socket: NETWORK_STREAM_SOCKET): BOOLEAN
		require
			socket_attached: client_socket /= Void
			socket_valid: client_socket.is_open_read and then client_socket.is_open_write
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
				send_message (client_socket, l_http_request.answer.reply_header + l_http_request.answer.reply_text)
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

	receive_message_internal (socket: NETWORK_STREAM_SOCKET) : STRING
        require
            socket: socket /= Void and then not socket.is_closed
        local
        	end_of_stream : BOOLEAN
        	pos : INTEGER
        	line : STRING
        do
            from
                socket.read_line
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
                	socket.read_line
        		else
        			end_of_stream := True
        		end
        	end
		end

	send_message (client_socket : NETWORK_STREAM_SOCKET ; a_msg: STRING)
		local
			a_package : PACKET
            a_data : MANAGED_POINTER
            c_string : C_STRING
		do
			 create c_string.make (a_msg)
             create a_data.make_from_pointer (c_string.item, a_msg.count + 1)
             create a_package.make_from_managed_pointer (a_data)
             client_socket.send (a_package, 0)
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

end
