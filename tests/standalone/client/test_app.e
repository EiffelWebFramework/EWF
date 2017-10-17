note
	description: "[
			Enter class description here!
		]"

class
	TEST_APP

inherit
	SHARED_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- Instantiate Current object.
		local
			h, res: STRING
			i: INTEGER
			l_test_name: detachable READABLE_STRING_GENERAL
			choices: HASH_TABLE [READABLE_STRING_GENERAL, INTEGER]
		do
			create h.make_empty
			h.append_character ((0).to_character_8)
			h.append_character ((0).to_character_8)
			h.append_character ((255).to_character_8)
			h.append_character ((255).to_character_8)

			i := 0
			if attached execution_environment.arguments.argument (1) as tn then
				l_test_name := tn
			else
				create choices.make (tests.count)
				across
					tests as ic
				loop
					i := i + 1
					choices.force (ic.key, i)
					print (i.out + " - " + ic.key.out + "%N")
				end
				print (" > ")
				io.read_line
				res := io.last_string
				res.adjust
				if
					res.is_integer and then
					attached choices [res.to_integer] as tn
				then
					l_test_name := tn
				end
			end
			if
				l_test_name /= Void and then
				attached tests [l_test_name] as proc
			then
				proc.call ()
			else
				print ("Quit...%N")
			end
		end

	port_number: INTEGER = 9090

	hostname: STRING = "localhost"

	has_error: BOOLEAN

	tests: STRING_TABLE [PROCEDURE]
		once
			create Result.make (10)
			Result.force (agent cli_execute_get_request, "get_request")
			Result.force (agent execute_get_request (1, 0), "get_request (1,0)")
			Result.force (agent execute_get_request (10, 0), "get_request (10,0)")
			Result.force (agent execute_get_request (1, 10_000), "get_request (1, 10000)")
			Result.force (agent execute_get_request (10, 10_000), "get_request (10, 10000)")
			Result.force (agent execute_wait_for_ever, "wait_for_ever")
		end

feature -- Execution

	wait_ms (a_delay_ms: INTEGER; m: detachable READABLE_STRING_8)
		local
			i64: INTEGER_64
		do
			if a_delay_ms > 0 then
				if has_error then
					print ("[ERROR/WAIT] Skipped due to previous error%N")
				else

					i64 := a_delay_ms.as_integer_64 * {INTEGER_64} 1_000_000
					if m /= Void then
						print ("[WAIT] " + i64.out + " nanoseconds -> " + m + "%N")
					else
						print ("[WAIT] " + i64.out + " nanoseconds.%N")
					end
					execution_environment.sleep (i64) -- nanoseconds
					print ("[WAIT] done.%N")
				end
			end
		end

	cli_execute_get_request
		local
			i,n: INTEGER
			rq_nb: INTEGER
			sl_val: INTEGER
		do
			if attached execution_environment.arguments as args then
				n := args.argument_count
				rq_nb := 1
				sl_val := 0
				i := 1
				if n > i then
					if args.argument (i).is_case_insensitive_equal_general ("get_request") then
						if n >= i + 1 then
							rq_nb := args.argument (i + 1).to_integer
							if n >= i + 2 then
								sl_val := args.argument (i + 2).to_integer
							end
						end
						execute_get_request (rq_nb, sl_val)
					end
				end
			end
		end

	execute_get_request (rq_nb: INTEGER; a_delay_ms: INTEGER)
		require
			rq_nb > 0
		local
			l_socket: NETWORK_STREAM_SOCKET
			l_packet: PACKET
			l_header_done, l_done: BOOLEAN
			line, txt: READABLE_STRING_8
			h: STRING
			len: INTEGER
			i: INTEGER
		do
			create l_socket.make_client_by_port (port_number, hostname)
			l_socket.connect

			from
				i := rq_nb
			until
				i <= 0
			loop
				i := i - 1

				print ("GET /test/"+ i.out +" HTTP/1.1%N")
--				socket_put_string (l_socket, "GET /test/"+ i.out +" HTTP/1.1%R%N")

				socket_put_string (l_socket, "GET /test/"+ i.out)
				wait_ms (a_delay_ms, "inside GET request line")
				socket_put_string (l_socket, " HTTP/1.1%R%N")
				wait_ms (a_delay_ms, "before Host")
				socket_put_string (l_socket, "Host: localhost:9090%R%N")
				wait_ms (a_delay_ms, "before Accept")
				socket_put_string (l_socket, "Accept: */*%R%N")
				wait_ms (a_delay_ms, "before CRNL")
				socket_put_string (l_socket, "%R%N")
				wait_ms (a_delay_ms, "before reading!")

				if not has_error then
					from
						l_done := False
						l_header_done := False
						create h.make_empty
					until
						l_done
					loop
						if l_header_done then
							l_socket.read_stream (len)
							txt := l_socket.last_string
							print ("BODY:%N")
							print (txt)
							print ("%N")
							if txt.count /= len then
								print ("BAD len: " + txt.count.out + " /= " + len.out + "%N")
							end
							l_done := True
						else
							l_socket.read_line
							line := l_socket.last_string
							if l_socket.was_error then
								l_done := True
							elseif line.is_empty or (line.count = 1 and line[1] = '%R') then
								l_header_done := True
							else
								if line.starts_with_general ("Content-Length:") then
									len := line.substring (16, line.count).to_integer
								end
								h.append (line)
								h.append ("%R%N")

								print ("HEADER:")
								print (line)
								print ("%N")
							end
						end
					end
				end
			end
		end

	execute_wait_for_ever
		local
			l_socket: NETWORK_STREAM_SOCKET
			l_packet: PACKET
		do
			create l_socket.make_client_by_port(9090, "localhost")
			l_socket.connect

			create l_packet.make(1)
			l_packet.put_element('a', 0)

			l_socket.send(l_packet, 0)

			from

			until
				not l_socket.is_connected
			loop

			end
		end

	socket_put_string (a_socket: NETWORK_STREAM_SOCKET; s: STRING_8)
		local
			retried: BOOLEAN
			t: STRING
			i: INTEGER
		do
			if has_error then
				create t.make_from_string (s)
				i := t.index_of ('%N', 1)
				if i > 0 then
					t.keep_head (i - 1)
				end
				t.adjust
				print ("[ERROR] Skip put_string ("+ s +"..)%N")
			elseif retried then
				has_error := True
			else
				a_socket.put_string (s)
			end
		rescue
			retried := True
			retry
		end

end
