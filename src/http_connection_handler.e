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

	make (a_main_server: like main_server; a_name: STRING)
			-- Creates a {HTTP_CONNECTION_HANDLER}, assigns the main_server and sets the current_request_message to empty.
			--
			-- `a_main_server': The main server object
			-- `a_name': The name of this module
		do
			Precursor (a_main_server, a_name)
			create method.make_empty
			create uri.make_empty
			create request_header.make_empty
			create request_header_map.make (10)
		end

feature -- Execution

	receive_message_and_send_reply (client_socket: TCP_STREAM_SOCKET)
		local
			l_input: HTTP_INPUT_STREAM
			l_output: HTTP_OUTPUT_STREAM
		do
			create l_input.make (client_socket)
			create l_output.make (client_socket)

            analyze_request_message (l_input)
			process_request (uri, method, request_header_map, request_header, l_input, l_output)
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
		deferred
		end

feature {NONE} -- Access

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

feature -- Parsing

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


	analyze_request_message (a_input: HTTP_INPUT_STREAM)
        require
            input_readable: a_input /= Void and then a_input.is_readable
        local
        	end_of_stream : BOOLEAN
        	pos : INTEGER
        	line : STRING
        	txt: STRING
        do
            create txt.make (64)
			a_input.read_line
			line := a_input.last_string
			analyze_request_line (line)
			txt.append (line)
			txt.append_character ('%N')

			request_header := txt
            from
                a_input.read_line
            until
                end_of_stream
            loop
                line := a_input.last_string
                print ("%N" +line+ "%N")
                pos := line.index_of (':',1)
               	request_header_map.put (line.substring (pos + 1, line.count), line.substring (1,pos-1))
                txt.append (line)
                txt.append_character ('%N')
                if line.is_empty or else line[1] = '%R' then
        			end_of_stream := True
        		else
        			a_input.read_line
                end
        	end
		end

	analyze_request_line (line: STRING)
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
	request_header_attached: request_header /= Void

end
