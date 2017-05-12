note
	description: "[
			Enter class description here!
		]"

class
	TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Instantiate Current object.
		do
			execute
		end

feature -- Execution

	execute
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

end
