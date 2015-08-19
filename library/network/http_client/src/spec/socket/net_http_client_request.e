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
	net_http_client_version: STRING = "0.1"

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
			l_authorization: HTTP_AUTHORIZATION
			l_session: NET_HTTP_CLIENT_SESSION
			l_platform: STRING
			l_useragent: STRING
			l_upload_data: detachable READABLE_STRING_8
			l_form_data: detachable HASH_TABLE [READABLE_STRING_32, READABLE_STRING_32]
			ctx: like context
			l_upload_file: detachable RAW_FILE
			l_upload_filename: detachable READABLE_STRING_GENERAL
			l_form_string: STRING
			l_mime_type_mapping: HTTP_FILE_EXTENSION_MIME_MAPPING
			l_mime_type: STRING
			l_fn_extension: READABLE_STRING_GENERAL
			l_i: INTEGER
		do
			ctx := context
			create Result.make (url)

			create l_form_string.make_empty

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

			-- add headers for authorization
			if attached l_uri.userinfo as l_userinfo then
				if attached l_uri.username as u_name then
					if attached l_uri.password as u_pass then
						create l_authorization.make_basic_auth (u_name, u_pass)
						if attached l_authorization.http_authorization as auth then
							headers.extend (auth, "Authorization")
						end
						check headers.has_key ("Authorization") end
					end
				end
			end

			create l_request_uri.make_from_string (l_uri.path)
			if attached l_uri.query as l_query then
				l_request_uri.append_character ('?')
				l_request_uri.append (l_query)
			end

			-- add headers for user agent
			if {PLATFORM}.is_unix then
				l_platform := "Unix"
			else
				if {PLATFORM}.is_mac then
					l_platform := "Mac"
				else
					l_platform := "Windows"
				end
			end
			if l_platform /= Void then
				l_useragent := "eiffelhttpclient/" + net_http_client_version + " (" + l_platform + ")"
				headers.extend (l_useragent, "User-Agent")
			end


			-- handle sending data
			if attached ctx then
				if ctx.has_upload_filename then
					l_upload_filename := ctx.upload_filename
				end

				if ctx.has_upload_data then
					l_upload_data := ctx.upload_data
				end

				if ctx.has_form_data then
					l_form_data := ctx.form_parameters
					check non_empty_form_data: not l_form_data.is_empty end
					if l_upload_data = Void and l_upload_filename = Void then
						-- Send as form-urlencoded
						headers.extend ("application/x-www-form-urlencoded", "Content-Type")
						l_upload_data := ctx.form_parameters_to_url_encoded_string
						headers.extend (l_upload_data.count.out, "Content-Length")

					else
						-- create form
						headers.extend ("multipart/form-data; boundary=----------------------------5eadfcf3bb3e", "Content-Type")
						if attached l_form_data then
							headers.extend ("*/*", "Accept")
							from
								l_form_data.start
							until
								l_form_data.after
							loop
								l_form_string.append ("------------------------------5eadfcf3bb3e")
								l_form_string.append (http_end_of_header_line)
								l_form_string.append ("Content-Disposition: form-data; name=")
								l_form_string.append ("%"" + l_form_data.key_for_iteration + "%"")
								l_form_string.append (http_end_of_header_line)
								l_form_string.append (http_end_of_header_line)
								l_form_string.append (l_form_data.item_for_iteration)
								l_form_string.append (http_end_of_header_line)
								l_form_data.forth
							end

							if  l_upload_filename /= Void then
								-- get file extension, otherwise set default
								l_mime_type := "application/octet-stream"
								create l_mime_type_mapping.make_default
								l_fn_extension := l_upload_filename.tail (l_upload_filename.count - l_upload_filename.last_index_of ('.', l_upload_filename.count))
								if attached l_mime_type_mapping.mime_type (l_fn_extension) as mime then
									l_mime_type := mime
								end

								l_form_string.append ("------------------------------5eadfcf3bb3e")
								l_form_string.append (http_end_of_header_line)
								l_form_string.append ("Content-Disposition: form-data; name=%"" + l_upload_filename.as_string_32 + "%"")
							    l_form_string.append ("; filename=%"" + l_upload_filename + "%"")
								l_form_string.append (http_end_of_header_line)
								l_form_string.append ("Content-Type: ")
								l_form_string.append (l_mime_type)
								l_form_string.append (http_end_of_header_line)
								l_form_string.append (http_end_of_header_line)

								create l_upload_file.make_with_name (l_upload_filename)
								if l_upload_file.exists and then l_upload_file.is_readable then
									l_upload_file.open_read
									l_upload_file.read_stream (l_upload_file.count)
									l_form_string.append (l_upload_file.last_string)
									end
								l_form_string.append (http_end_of_header_line)
							end
							l_form_string.append ("------------------------------5eadfcf3bb3e--")

							l_upload_data := l_form_string
							headers.extend (l_upload_data.count.out, "Content-Length")
						end
					end
				else
					if request_method.is_case_insensitive_equal ("POST") then
						if ctx /= Void then
							if ctx.has_upload_data then
								l_upload_data := ctx.upload_data
								if l_upload_data /= Void then
									headers.extend ("application/x-www-form-urlencoded", "Content-Type")
									headers.extend (l_upload_data.count.out, "Content-Length")
								end
							elseif ctx.has_upload_filename then
								if l_upload_filename /= Void then
									create l_upload_file.make_with_name (l_upload_filename)
									if l_upload_file.exists and then l_upload_file.is_readable then
										headers.extend (l_upload_file.count.out, "Content-Length")
										l_upload_file.open_read
									end
									check l_upload_file /= Void end
								end
							end
						end
					end
				end
			end

			-- handle put requests
			if request_method.is_case_insensitive_equal ("PUT") then
				if ctx /= Void then
					if ctx.has_upload_filename then
						if l_upload_filename /= Void then
							create l_upload_file.make_with_name (l_upload_filename)
							if l_upload_file.exists and then l_upload_file.is_readable then
								headers.extend (l_upload_file.count.out, "Content-Length")
								l_upload_file.open_read
							end
							check l_upload_filename /= Void end
						end

					end
				end


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
				s.append (http_end_of_header_line)
				if attached session.cookie as cookie then
					s.append ("Cookie: " + cookie + http_end_of_header_line)
				end
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

				if l_upload_data /= Void then
					s.append (l_upload_data)
					s.append (http_end_of_header_line)
				end
				if attached l_upload_file then
					if not l_upload_file.after then
						from
						until
							l_upload_file.after
						loop
							l_upload_file.read_line
							s.append (l_upload_file.last_string)
						end
					end
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
					elseif s.starts_with_general ("Set-Cookie:") then
						i := s.index_of (':', 1)
						s.remove_head (i)
						s.left_adjust
						s.right_adjust
						session.set_cookie (s)
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

				-- follow redirect
				if l_location /= Void then
					if current_redirects < max_redirects then
						current_redirects := current_redirects + 1
						url := l_location
						Result := response
					end
				end

				current_redirects := 0
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
