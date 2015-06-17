note
	description: "[
				Specific implementation of HTTP_CLIENT_REQUEST based on Eiffel NET library
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	NET_HTTP_CLIENT_REQUEST

inherit
	HTTP_CLIENT_REQUEST
		redefine
			session
		end

	TRANSFER_COMMAND_CONSTANTS

	REFACTORING_HELPER

create
	make

feature {NONE} -- Internal	

	session: NET_HTTP_CLIENT_SESSION

feature -- Access

	response: HTTP_CLIENT_RESPONSE
			-- <Precursor>
		local
			l_uri: URI
			l_host: READABLE_STRING_8
			l_request_uri: STRING
			l_url: HTTP_URL
			socket: NETWORK_STREAM_SOCKET
			s: STRING
			l_message: STRING
			i,j: INTEGER
			l_content_length: INTEGER
			l_location: detachable READABLE_STRING_8
			l_port: INTEGER
		do
			create Result.make (url)

				-- Get URL data
			create l_uri.make_from_string (url)
			l_port := l_uri.port
			if l_port = 0 then
				if url.starts_with_general ("https://") then
					l_port := 443
				else
					l_port := 80
				end
			end
			if attached l_uri.host as h then
				l_host := h
			else
				create l_url.make (url)
				l_host := l_url.host
			end
			if attached l_uri.userinfo as l_userinfo then
					-- TODO: Add support for HTTP Authorization
					-- See {HTTP_AUTHORIZATION} from http_authorization EWF library.
			end

			create l_request_uri.make_from_string (l_uri.path)
			if attached l_uri.query as l_query then
				l_request_uri.append_character ('?')
				l_request_uri.append (l_query)
			end

				-- Connect			
			create socket.make_client_by_port (l_port, l_host)
			socket.set_timeout (timeout)
			socket.set_connect_timeout (connect_timeout)
			socket.connect
			if socket.is_connected then
				create s.make_from_string (request_method.as_upper)
				s.append_character (' ')
				s.append (l_request_uri)
				s.append_character (' ')
				s.append (Http_version)
				s.append (Http_end_of_header_line)

				s.append (Http_host_header)
				s.append (": ")
				s.append (l_host)
				if headers.is_empty then
					s.append (Http_end_of_command)
				else
					across
						headers as ic
					loop
						s.append (ic.key)
						s.append (": ")
						s.append (ic.item)
						s.append (Http_end_of_header_line)
					end
					s.append (Http_end_of_header_line)
				end

				socket.put_string (s)

					-- Get header message
				from
					l_content_length := -1
					create l_message.make_empty
					socket.read_line
					s := socket.last_string
				until
					s.same_string ("%R") or not socket.is_readable
				loop
					l_message.append (s)
					l_message.append_character ('%N')
						-- Search for Content-Length is not yet set.
					if
						l_content_length = -1 and then -- Content-Length is not yet found.
						s.starts_with_general ("Content-Length:")
					then
						i := s.index_of (':', 1)
						check has_colon: i > 0 end
						s.remove_head (i)
						s.right_adjust -- Remove trailing %R
						if s.is_integer then
							l_content_length := s.to_integer
						end
					elseif
						l_location = Void and then
						s.starts_with_general ("Location:")
					then
						i := s.index_of (':', 1)
						check has_colon: i > 0 end
						s.remove_head (i)
						s.left_adjust -- Remove startung spaces
						s.right_adjust -- Remove trailing %R
						l_location := s
					end
						-- Next iteration
					socket.read_line
					s := socket.last_string
				end
				l_message.append (http_end_of_header_line)

					-- Get content if any.
				if
					l_content_length > 0 and
					socket.is_readable
				then
					socket.read_stream_thread_aware (l_content_length)
					if socket.bytes_read /= l_content_length then
						check full_content_read: False end
					end
					l_message.append (socket.last_string)
				end
				Result.set_response_message (l_message, context)
					-- Get status code.
				if attached Result.status_line as l_status_line then
					if l_status_line.starts_with ("HTTP/") then
						i := l_status_line.index_of (' ', 1)
						if i > 0 then
							i := i + 1
						end
					else
						i := 1
					end
						-- Get status code token.
					if i > 0 then
						j := l_status_line.index_of (' ', i)
						if j > i then
							s := l_status_line.substring (i, j - 1)
							if s.is_integer then
								Result.set_status (s.to_integer)
							end
						end
					end
				end
				if l_location /= Void then
						-- TODO: add redirection support.
						-- See if it could be similar to libcurl implementation
						-- otherwise, maybe update the class HTTP_CLIENT_RESPONSE.					
				end
			else
				Result.set_error_message ("Could not connect")
			end
		end
note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
