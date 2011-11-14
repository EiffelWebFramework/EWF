note
	description: "Summary description for {HTTP_CONNECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTP_CONNECTION_HANDLER

inherit
	HTTP_HANDLER
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_main_server: like main_server)
			-- Creates a {HTTP_CONNECTION_HANDLER}, assigns the main_server and sets the current_request_message to empty.
			--
			-- `a_main_server': The main server object
		do
			Precursor (a_main_server)
			reset
		end

	reset
		do
			create method.make_empty
			create uri.make_empty
			create request_header.make_empty
			create request_header_map.make (10)
			remote_info := Void
		end

feature -- Execution

	receive_message_and_send_reply (client_socket: TCP_STREAM_SOCKET)
		local
			l_remote_info: detachable like remote_info
		do
			create l_remote_info
			if attached client_socket.peer_address as l_addr then
				l_remote_info.addr := l_addr.host_address.host_address
				l_remote_info.hostname := l_addr.host_address.host_name
				l_remote_info.port := l_addr.port
				remote_info := l_remote_info
			end

            analyze_request_message (client_socket)
			process_request (Current, client_socket)
			reset
		end

feature -- Request processing

	process_request (a_handler: HTTP_CONNECTION_HANDLER; a_socket: TCP_STREAM_SOCKET)
			-- Process request ...
		require
			a_handler_attached: a_handler /= Void
			a_uri_attached: a_handler.uri /= Void
			a_method_attached: a_handler.method /= Void
			a_header_map_attached: a_handler.request_header_map /= Void
			a_header_text_attached: a_handler.request_header /= Void
			a_socket_attached: a_socket /= Void
		deferred
		end

feature -- Access

	request_header: STRING
			-- Header' source

	request_header_map : HASH_TABLE [STRING,STRING]
			-- Contains key:value of the header

	method: STRING
			-- http verb

	uri: STRING
			--  http endpoint		

	version: detachable STRING
			--  http_version
			--| unused for now

	remote_info: detachable TUPLE [addr: STRING; hostname: STRING; port: INTEGER]

feature -- Parsing

	analyze_request_message (a_socket: TCP_STREAM_SOCKET)
        require
            input_readable: a_socket /= Void and then a_socket.is_open_read
        local
        	end_of_stream : BOOLEAN
        	pos,n : INTEGER
        	line : detachable STRING
			k, val: STRING
        	txt: STRING
        do
            create txt.make (64)
			line := next_line (a_socket)
			if line /= Void then
				analyze_request_line (line)
				txt.append (line)
				txt.append_character ('%N')

				request_header := txt
				from
					line := next_line (a_socket)
				until
					line = Void or end_of_stream
				loop
					n := line.count
					if is_verbose then
						print ("%N" + line)
					end
					pos := line.index_of (':',1)
					if pos > 0 then
						k := line.substring (1, pos-1)
						if line [pos+1].is_space then
							pos := pos + 1
						end
						if line [n] = '%R' then
							n := n - 1
						end
						val := line.substring (pos + 1, n)
						request_header_map.put (val, k)
					end
					txt.append (line)
					txt.append_character ('%N')
					if line.is_empty or else line [1] = '%R' then
						end_of_stream := True
					else
						line := next_line (a_socket)
					end
				end
			end
		end

	analyze_request_line (line: STRING)
		require
			line /= Void
		local
			pos, next_pos: INTEGER
		do
			if is_verbose then
				print ("%N## Parse HTTP request line ##")
				print ("%N")
				print (line)
			end
			pos := line.index_of (' ', 1)
			method := line.substring (1, pos - 1)
			next_pos := line.index_of (' ', pos + 1)
			uri := line.substring (pos + 1, next_pos - 1)
			version := line.substring (next_pos + 1, line.count)
		ensure
			not_void_method: method /= Void
		end

	next_line (a_socket: TCP_STREAM_SOCKET): detachable STRING
		require
			is_readable: a_socket.is_open_read
		do
			if a_socket.socket_ok then
				a_socket.read_line_thread_aware
				Result := a_socket.last_string
			end
		end

invariant
	request_header_attached: request_header /= Void

note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
