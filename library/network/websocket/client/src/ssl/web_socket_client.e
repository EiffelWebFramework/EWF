note
	description: "[
		API to perform actions like opening and closing the connection, sending and receiving messages, and listening
		for events triggered by the server
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WEB_SOCKET_CLIENT

inherit
	WEB_SOCKET_CLIENT_I

feature -- Status report

	is_ssl_supported: BOOLEAN = True

feature -- Factory

	new_socket (a_port: INTEGER; a_host: STRING): HTTP_STREAM_SOCKET
		local
			l_ssl: HTTP_STREAM_SSL_SOCKET
		do
			if is_tunneled then
				create l_ssl.make_client_by_port (a_port, a_host)
				Result := l_ssl
				if attached ssl_protocol as l_prot then
					if l_prot.is_case_insensitive_equal ("ssl_2_3") then
						l_ssl.set_ssl_protocol_to_ssl_2_or_3
					elseif l_prot.is_case_insensitive_equal ("tls_1_0") then
						l_ssl.set_ssl_protocol_to_tls_1_0
					elseif l_prot.is_case_insensitive_equal ("tls_1_1") then
						l_ssl.set_ssl_protocol_to_tls_1_1
					elseif l_prot.is_case_insensitive_equal ("tls_1_2") then
						l_ssl.set_ssl_protocol_to_tls_1_2
					elseif l_prot.is_case_insensitive_equal ("dtls_1_0") then
						l_ssl.set_ssl_protocol_to_dtls_1_0
					else -- Default
						l_ssl.set_ssl_protocol_to_tls_1_2
					end
				end
				if attached ssl_key_file as k then
					l_ssl.set_key_file_path (k)
				end
				if attached ssl_certificate_file as c then
					l_ssl.set_certificate_file_path (c)
				end
			else
				create {HTTP_STREAM_SOCKET} Result.make_client_by_port (a_port, a_host)
			end
		end

end
