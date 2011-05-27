note
	description: "Summary description for {HTTP_SERVER_CONFIGURATION}."
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_SERVER_CONFIGURATION

create
	make

feature {NONE} -- Initialization

	make
		do
			http_server_port := 80
			max_tcp_clients := 100
			socket_accept_timeout := 1_000
			socket_connect_timeout := 5_000
			document_root := "htdocs"
			force_single_threaded := False
		end

feature -- Access

	Server_details : STRING = "Server : NANO Eiffel Server"

	document_root: STRING assign set_document_root
	http_server_port: INTEGER assign set_http_server_port
	max_tcp_clients: INTEGER assign set_max_tcp_clients
	socket_accept_timeout: INTEGER assign set_socket_accept_timeout
	socket_connect_timeout: INTEGER assign set_socket_connect_timeout
	force_single_threaded: BOOLEAN assign set_force_single_threaded

feature -- Element change

	set_http_server_port (v: like http_server_port)
		do
			http_server_port := v
		end

	set_document_root (v: like document_root)
		do
			document_root := v
		end

	set_max_tcp_clients (v: like max_tcp_clients)
		do
			max_tcp_clients := v
		end

	set_socket_accept_timeout (v: like socket_accept_timeout)
		do
			socket_accept_timeout := v
		end

	set_socket_connect_timeout (v: like socket_connect_timeout)
		do
			socket_connect_timeout := v
		end

	set_force_single_threaded (v: like force_single_threaded)
		do
			force_single_threaded := v
		end


end
