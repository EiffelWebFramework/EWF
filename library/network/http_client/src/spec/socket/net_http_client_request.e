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

	SHARED_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Internal	

	session: NET_HTTP_CLIENT_SESSION
	net_http_client_version: STRING = "0.1"

feature -- Access

	response: HTTP_CLIENT_RESPONSE
			-- <Precursor>
		local
			redirection_response: detachable like response
			l_uri: URI
			l_header_key: READABLE_STRING_8
			l_host: READABLE_STRING_8
			l_cookie: detachable READABLE_STRING_8
			l_request_uri: STRING
			l_url: HTTP_URL
			socket: NETWORK_STREAM_SOCKET
			s: STRING
			l_message: STRING
			l_content_length: INTEGER
			l_location: detachable READABLE_STRING_8
			l_port: INTEGER
			l_authorization: HTTP_AUTHORIZATION
			l_platform: STRING
			l_upload_data: detachable READABLE_STRING_8
			l_form_data: detachable HASH_TABLE [READABLE_STRING_32, READABLE_STRING_32]
			ctx: like context
			l_upload_file: detachable RAW_FILE
			l_upload_filename: detachable READABLE_STRING_GENERAL
			l_form_string: STRING
			l_mime_type_mapping: HTTP_FILE_EXTENSION_MIME_MAPPING
			l_mime_type: STRING
			l_fn_extension: READABLE_STRING_GENERAL
			l_prev_header: READABLE_STRING_8
			l_boundary: READABLE_STRING_8
			l_is_http_1_0: BOOLEAN
			retried: BOOLEAN
		do
			if not retried then
				ctx := context
				if ctx /= Void then
					l_is_http_1_0 := attached ctx.http_version as l_http_version and then l_http_version.same_string ("HTTP/1.0")
				end
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
				if not headers.has ("Authorization") then
					if
						attached username as u_name and
						attached password as u_pass
					then
						create l_authorization.make_basic_auth (u_name, u_pass)
						if attached l_authorization.http_authorization as auth then
							headers.extend (auth, "Authorization")
						end
						check headers.has_key ("Authorization") end
					end
				end

				create l_request_uri.make_from_string (l_uri.path)
				if attached l_uri.query as l_query then
					l_request_uri.append_character ('?')
					l_request_uri.append (l_query)
				end

					-- add computed header User-Agent if not yet set.
				if not headers.has ("User-Agent") then
					if {PLATFORM}.is_unix then
						l_platform := "Unix"
					elseif {PLATFORM}.is_windows then
						l_platform := "Windows"
					elseif {PLATFORM}.is_mac then
						l_platform := "Mac"
					elseif {PLATFORM}.is_vms then
						l_platform := "VMS"
					elseif {PLATFORM}.is_vxworks then
						l_platform := "VxWorks"
					else
						l_platform := "Unknown"
					end
					headers.extend ("eiffelhttpclient/" + net_http_client_version + " (" + l_platform + ")", "User-Agent")
				end

					-- handle sending data
				if ctx /= Void then
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
							headers.force (l_upload_data.count.out, "Content-Length")

						else
								-- create form
							l_boundary := new_mime_boundary
							headers.extend ("multipart/form-data; boundary=" + l_boundary, "Content-Type")
							if l_form_data /= Void then
								headers.extend ("*/*", "Accept")
								from
									l_form_data.start
								until
									l_form_data.after
								loop
									l_form_string.append (l_boundary)
									l_form_string.append (http_end_of_header_line)
									l_form_string.append ("Content-Disposition: form-data; name=")
									l_form_string.append ("%"" + l_form_data.key_for_iteration + "%"")
									l_form_string.append (http_end_of_header_line)
									l_form_string.append (http_end_of_header_line)
									l_form_string.append (l_form_data.item_for_iteration)
									l_form_string.append (http_end_of_header_line)
									l_form_data.forth
								end

								if l_upload_filename /= Void then
										-- get file extension, otherwise set default
									l_mime_type := "application/octet-stream"
									create l_mime_type_mapping.make_default
									l_fn_extension := l_upload_filename.tail (l_upload_filename.count - l_upload_filename.last_index_of ('.', l_upload_filename.count))
									if attached l_mime_type_mapping.mime_type (l_fn_extension) as mime then
										l_mime_type := mime
									end

									l_form_string.append (l_boundary)
									l_form_string.append (http_end_of_header_line)
									l_form_string.append ("Content-Disposition: form-data; name=%"" + l_upload_filename.as_string_32 + "%"")
								    l_form_string.append ("; filename=%"" + l_upload_filename + "%"")
									l_form_string.append (http_end_of_header_line)
									l_form_string.append ("Content-Type: ")
									l_form_string.append (l_mime_type)
									l_form_string.append (http_end_of_header_line)
									l_form_string.append (http_end_of_header_line)

									create l_upload_file.make_with_name (l_upload_filename)
									if l_upload_file.exists and then l_upload_file.is_access_readable then
										append_file_content_to (l_upload_file, l_upload_file.count, l_form_string)
											-- Reset l_upload_file to Void, since the related content is already processed.
										l_upload_file := Void
									end
									l_form_string.append (http_end_of_header_line)
								end
								l_form_string.append (l_boundary + "--") --| end

								l_upload_data := l_form_string
								headers.extend (l_upload_data.count.out, "Content-Length")
							end
						end
					elseif
						request_method.is_case_insensitive_equal ("POST")
						or else request_method.is_case_insensitive_equal ("PUT")
					then
						if l_upload_data /= Void then
							check ctx.has_upload_data end
							headers.extend ("application/x-www-form-urlencoded", "Content-Type")
							headers.extend (l_upload_data.count.out, "Content-Length")
						elseif l_upload_filename /= Void then
							check ctx.has_upload_filename end
							create l_upload_file.make_with_name (l_upload_filename)
							if l_upload_file.exists and then l_upload_file.readable then
								headers.extend (l_upload_file.count.out, "Content-Length")
							end
							check l_upload_file /= Void end
						end

					end
				end

					-- Connect			
				create socket.make_client_by_port (l_port, l_host)
				socket.set_connect_timeout (connect_timeout)
				socket.set_timeout (timeout)
				socket.connect
				if socket.is_connected then
						-- FIXME: check usage of headers and specific header variable.
						--| only one Cookie: is allowed, so merge multiple into one;
						--| if Host is in header, use that one.
						-- Compute Request line.
					create s.make_from_string (request_method.as_upper)
					s.append_character (' ')
					s.append (l_request_uri)
					s.append_character (' ')
					if l_is_http_1_0 then
						s.append ("HTTP/1.0")
					else
						s.append ("HTTP/1.1")
					end
					s.append (Http_end_of_header_line)

						-- Compute Header Host:
					s.append (Http_host_header)
					s.append (": ")
					if attached headers [Http_host_header] as h_host then
						s.append (h_host)
					else
						s.append (l_host)
					end
					s.append (http_end_of_header_line)

						-- Append the given request headers
					l_cookie := Void
					if headers.is_empty then
						s.append (Http_end_of_command)
					else
						across
							headers as ic
						loop
							l_header_key := ic.key
							if l_header_key.same_string_general ("Host") then
									-- FIXME: already handled elsewhere!
							elseif l_header_key.same_string_general ("Cookie") then
									-- FIXME: need cookie merging.
								l_cookie := ic.item
							else
								s.append (ic.key)
								s.append (": ")
								s.append (ic.item)
								s.append (Http_end_of_header_line)
							end
						end
						s.append (Http_end_of_header_line)
					end

						-- Compute Header Cookie:  if needed
						-- Get session cookie
					if l_cookie = Void then
						l_cookie := session.cookie
					else
							-- Overwrite potential session cookie, if specified by the user.
					end
					if l_cookie /= Void then
						s.append ("Cookie: ")
						s.append (l_cookie)
						s.append (http_end_of_header_line)
					end

					if l_upload_data /= Void then
						s.append (l_upload_data)
						s.append (http_end_of_header_line)
					end
						--| Note that any remaining file to upload will be done directly via the socket
						--| to optimize memory usage

						--| Send request
					if socket.ready_for_writing then
						socket.put_string (s)
							--| Send remaining payload data, if needed.
						if l_upload_file /= Void then
								-- i.e: not yet processed
							append_file_content_to_socket (l_upload_file, l_upload_file.count, socket)
						end

							--| Get response.
							--| Get header message
						if socket.ready_for_reading then
							create l_message.make_empty
							append_socket_header_content_to (socket, l_message)
							l_prev_header := Result.raw_header
							Result.set_raw_header (l_message.string)
							l_content_length := -1
							if attached Result.header ("Content-Length") as s_len and then s_len.is_integer then
								l_content_length := s_len.to_integer
							end
							l_location := Result.header ("Location")
							if attached Result.header ("Set-Cookies") as s_cookies then
								session.set_cookie (s_cookies)
							end
							l_message.append (http_end_of_header_line)

								-- Get content if any.
							append_socket_content_to (Result, socket, l_content_length, l_message)
								-- Restore previous header
							Result.set_raw_header (l_prev_header)
								-- Set message
							Result.set_response_message (l_message, ctx)
								-- Check status code.
							check status_coherent: attached Result.status_line as l_status_line implies l_status_line.has_substring (Result.status.out) end

								-- follow redirect
							if l_location /= Void then
								if current_redirects < max_redirects then
									current_redirects := current_redirects + 1
									initialize (l_location, ctx)
									redirection_response := response
									redirection_response.add_redirection (Result.status_line, Result.raw_header, Result.body)
									Result := redirection_response
								end
							end

							current_redirects := current_redirects - 1
						else
							Result.set_error_message ("Read Timeout")
						end
					else
						Result.set_error_message ("Write Timeout")
					end
				else
					Result.set_error_message ("Could not connect")
				end
			else
				create Result.make (url)
				Result.set_error_message ("Error: internal error")
			end
		rescue
			retried := True
			retry
		end

feature {NONE} -- Helpers

	append_file_content_to_socket (a_file: FILE; a_len: INTEGER; a_output: NETWORK_STREAM_SOCKET)
			-- Append `a_file' content to `a_output'.
			-- If `a_len' >= 0 then read only `a_len' characters.
		require
			a_file_readable: a_file.exists and then a_file.is_access_readable
		local
			l_was_open: BOOLEAN
			l_count: INTEGER
		do
			if a_len >= 0 then
				l_count := a_len
			else
				l_count := a_file.count
			end
			if l_count > 0 then
				l_was_open := a_file.is_open_read
				if a_file.is_open_read then
					l_was_open := True
				else
					a_file.open_read
				end
				from
				until
					l_count = 0 or a_file.exhausted
				loop
					a_file.read_stream_thread_aware (l_count.min (2_048))
					a_output.put_string (a_file.last_string)
					l_count := l_count - a_file.bytes_read
				end
				if not l_was_open then
					a_file.close
				end
			end
		end

	append_file_content_to (a_file: FILE; a_len: INTEGER; a_output: STRING)
			-- Append `a_file' content to `a_output'.
			-- If `a_len' >= 0 then read only `a_len' characters.
		require
			a_file_readable: a_file.exists and then a_file.is_access_readable
		local
			l_was_open: BOOLEAN
			l_count: INTEGER
		do
			if a_len >= 0 then
				l_count := a_len
			else
				l_count := a_file.count
			end
			if l_count > 0 then
				l_was_open := a_file.is_open_read
				if a_file.is_open_read then
					l_was_open := True
				else
					a_file.open_read
				end
				from

				until
					l_count = 0 or a_file.exhausted
				loop
					a_file.read_stream_thread_aware (l_count.min (2_048))
					a_output.append (a_file.last_string)
					l_count := l_count - a_file.bytes_read
				end
				if not l_was_open then
					a_file.close
				end
			end
		end

	append_socket_header_content_to (a_socket: NETWORK_STREAM_SOCKET; a_output: STRING)
			-- Get header from `a_socket' into `a_output'.
		local
			s: READABLE_STRING_8
		do
			from
				s := ""
			until
				s.same_string ("%R") or not a_socket.readable
			loop
				a_socket.read_line_thread_aware
				s := a_socket.last_string
				if s.same_string ("%R") then
						-- Reach end of header
--					a_output.append (http_end_of_header_line)
				else
					a_output.append (s)
					a_output.append_character ('%N')
				end
			end
		end

	append_socket_content_to (a_response: HTTP_CLIENT_RESPONSE; a_socket: NETWORK_STREAM_SOCKET; a_len: INTEGER; a_buffer: STRING)
			-- Get content from `a_socket' and append it to `a_buffer'.
			-- If `a_len' is negative, try to get as much as possible,
			-- this is probably HTTP/1.0 without any Content-Length.
		local
			s: STRING_8
			n,pos, l_chunk_size, l_count: INTEGER
			hexa2int: HEXADECIMAL_STRING_TO_INTEGER_CONVERTER
		do
			if a_socket.readable then
				if a_len >= 0 then
					from
						n := a_len
					until
						n = 0 or else not a_socket.readable or else a_response.error_occurred
					loop
						if a_socket.ready_for_reading then
							a_socket.read_stream_thread_aware (n)
							l_count := l_count + a_socket.bytes_read
							n := n - a_socket.bytes_read
							a_buffer.append (a_socket.last_string)
						else
							a_response.set_error_message ("Could not read chunked data, timeout")
						end
					end
					check full_content_read: l_count = a_len end
				elseif attached a_response.header ("Transfer-Encoding") as l_enc and then l_enc.is_case_insensitive_equal ("chunked") then
					from
						create hexa2int.make
						n := 1
					until
						n = 0 or not a_socket.readable
					loop
						a_socket.read_line_thread_aware -- Read chunk info
						s := a_socket.last_string
						s.right_adjust
						pos := s.index_of (';', 1)
						if pos > 0 then
							s.keep_head (pos - 1)
						end
						if s.is_empty then
							n := 0
						else
							hexa2int.parse_string_with_type (s, hexa2int.type_integer)
							if hexa2int.parse_successful then
								n := hexa2int.parsed_integer
							else
								n := 0
							end
						end
						if n > 0 then
							from
							until
								n = 0 or else not a_socket.readable or else a_response.error_occurred
							loop
								if a_socket.ready_for_reading then
									a_socket.read_stream_thread_aware (n)
									l_count := l_count + a_socket.bytes_read
									n := n - a_socket.bytes_read
									a_buffer.append (a_socket.last_string)
								else
									a_response.set_error_message ("Could not read chunked data, timeout")
								end
							end

							if a_socket.ready_for_reading then
								a_socket.read_character
								check a_socket.last_character = '%R' end
								a_socket.read_character
								check a_socket.last_character = '%N' end
							else
								a_response.set_error_message ("Could not read chunked data, timeout")
							end
						end
					end
				else
						-- No Content-Length and no chunked transfer encoding!
						-- maybe HTTP/1.0 ?
						-- FIXME: check solution!
					from
						l_count := 0
						l_chunk_size := 1_024
						n := l_chunk_size --| value to satisfy until condition on first loop.
					until
						n < l_chunk_size or not a_socket.readable
					loop
						if a_socket.ready_for_reading then
							a_socket.read_stream_thread_aware (l_chunk_size)
							s := a_socket.last_string
							n := a_socket.bytes_read
							l_count := l_count + n
							a_buffer.append (s)
						else
							a_response.set_error_message ("Could not read data, timeout")
						end
					end
				end
			end
		end

	new_mime_boundary: STRING
			-- New MIME boundary.
		do
				-- FIXME: better boundary creation
			Result := "----------------------------5eadfcf3bb3e"
		end

invariant
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
