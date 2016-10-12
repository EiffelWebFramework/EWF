note
	description: "[
			A fake SSL network stream socket... when SSL is disabled at compilation time.
			Its behavior is similar to HTTP_STREAM_SOCKET.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_STREAM_SSL_SOCKET

inherit
	HTTP_STREAM_SOCKET

create
	make, make_empty,
	make_client_by_port, make_client_by_address_and_port,
	make_server_by_port, make_server_by_address_and_port, make_loopback_server_by_port

create {HTTP_STREAM_SSL_SOCKET}
	make_from_descriptor_and_address

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
