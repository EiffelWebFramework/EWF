note
	description: "[
		API to perform actions like opening and closing the connection, sending and receiving messages, and listening
		for events.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WEB_SOCKET_EVENT_I

inherit
	WEB_SOCKET_CONSTANTS

	REFACTORING_HELPER

feature -- Web Socket Interface

	on_event (conn: HTTPD_STREAM_SOCKET; a_message: detachable READABLE_STRING_8; a_opcode: INTEGER)
			-- Called when a frame from the client has been receive
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		local
			l_message: READABLE_STRING_8
		do
			debug ("ws")
				print ("%Non_event (conn, a_message, " + opcode_name (a_opcode) + ")%N")
			end
			if a_message = Void then
				create {STRING} l_message.make_empty
			else
				l_message := a_message
			end

			if a_opcode = Binary_frame then
				on_binary (conn, l_message)
			elseif a_opcode = Text_frame then
				on_text (conn, l_message)
			elseif a_opcode = Pong_frame then
				on_pong (conn, l_message)
			elseif a_opcode = Ping_frame then
				on_ping (conn, l_message)
			elseif a_opcode = Connection_close_frame then
				on_connection_close (conn, "")
			else
				on_unsupported (conn, l_message, a_opcode)
			end
		end

	on_open (conn: HTTPD_STREAM_SOCKET)
			-- Called after handshake, indicates that a complete WebSocket connection has been established.
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		deferred
		end

	on_binary (conn: HTTPD_STREAM_SOCKET; a_message: READABLE_STRING_8)
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		deferred
		end

	on_pong (conn: HTTPD_STREAM_SOCKET; a_message: READABLE_STRING_8)
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		do
				-- log ("Its a pong frame")
				-- at first we ignore  pong
				-- FIXME: provide better explanation			
		end

	on_ping (conn: HTTPD_STREAM_SOCKET; a_message: READABLE_STRING_8)
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		do
			send (conn, Pong_frame, a_message)
		end

	on_text (conn: HTTPD_STREAM_SOCKET; a_message: READABLE_STRING_8)
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		deferred
		end

	on_unsupported (conn: HTTPD_STREAM_SOCKET; a_message: READABLE_STRING_8; a_opcode: INTEGER)
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		do
				-- do nothing
		end

	on_connection_close (conn: HTTPD_STREAM_SOCKET; a_message: detachable READABLE_STRING_8)
		require
			conn_attached: conn /= Void
			conn_valid: conn.is_open_read and then conn.is_open_write
		do
			send (conn, Connection_close_frame, "")
		end

	on_close (conn: detachable HTTPD_STREAM_SOCKET)
			-- Called after the WebSocket connection is closed.
		deferred
		end

feature {NONE} -- Implementation

	send (conn: HTTPD_STREAM_SOCKET; a_opcode:INTEGER; a_message: READABLE_STRING_8)
		local
			i: INTEGER
			l_chunk_size: INTEGER
			l_chunk: READABLE_STRING_8
			l_header_message: STRING
			l_message_count: INTEGER
			n: NATURAL_64
			retried: BOOLEAN
		do
			print (">>do_send (..., "+ opcode_name (a_opcode) +", ..)%N")
			if not retried then
				create l_header_message.make_empty
				l_header_message.append_code ((0x80 | a_opcode).to_natural_32)
				l_message_count := a_message.count
				n := l_message_count.to_natural_64
				if l_message_count > 0xffff then
						--! Improve. this code needs to be checked.
					l_header_message.append_code ((0 | 127).to_natural_32)
					l_header_message.append_character ((n |>> 56).to_character_8)
					l_header_message.append_character ((n |>> 48).to_character_8)
					l_header_message.append_character ((n |>> 40).to_character_8)
					l_header_message.append_character ((n |>> 32).to_character_8)
					l_header_message.append_character ((n |>> 24).to_character_8)
					l_header_message.append_character ((n |>> 16).to_character_8)
					l_header_message.append_character ((n |>> 8).to_character_8)
					l_header_message.append_character ( n.to_character_8)
				elseif l_message_count > 125 then
					l_header_message.append_code ((0 | 126).to_natural_32)
					l_header_message.append_code ((n |>> 8).as_natural_32)
					l_header_message.append_character (n.to_character_8)
				else
					l_header_message.append_code (n.as_natural_32)
				end
				conn.put_string (l_header_message)


				l_chunk_size := 16_384 -- 16K
				if l_message_count < l_chunk_size then
					conn.put_string (a_message)
				else
					from
						i := 0
					until
						l_chunk_size = 0
					loop
						debug ("ws")
							print ("Sending chunk " + (i + 1).out + " -> " + (i + l_chunk_size).out +" / " + l_message_count.out + "%N")
						end
						l_chunk := a_message.substring (i + 1, l_message_count.min (i + l_chunk_size))
						conn.put_string (l_chunk)
						if l_chunk.count < l_chunk_size then
							l_chunk_size := 0
						end
						i := i + l_chunk_size
					end
					debug ("ws")
						print ("Sending chunk done%N")
					end
				end
			else
					-- FIXME: what should be done on rescue?
			end
		rescue
			retried := True
			io.put_string ("Internal error in " + generator + ".do_send (conn, a_opcode=" + a_opcode.out + ", a_message) !%N")
			retry
		end

end
