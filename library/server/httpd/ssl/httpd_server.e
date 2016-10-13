note
	description: "[
			SSL enabled server
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	HTTPD_SERVER

inherit
	HTTPD_SERVER_I
		redefine
			new_listening_socket
		end

create
	make

feature {NONE} -- Factory

	new_listening_socket (a_addr: detachable INET_ADDRESS; a_http_port: INTEGER): HTTPD_STREAM_SOCKET
		local
			s_ssl: HTTPD_STREAM_SSL_SOCKET
		do
			if configuration.is_secure then
				if a_addr /= Void then
					create s_ssl.make_server_by_address_and_port (a_addr, a_http_port)
					Result := s_ssl
				else
					create s_ssl.make_server_by_port (a_http_port)
				end
				s_ssl.set_tls_protocol (configuration.ssl_protocol)
				if attached configuration.ca_crt as l_crt then
					s_ssl.set_certificate_file_name (l_crt)
				end
				if attached configuration.ca_key as l_key then
					s_ssl.set_key_file_name (l_key)
				end

				Result := s_ssl
			else
				Result := Precursor (a_addr, a_http_port)
			end
		end

note
	copyright: "2011-2016, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
