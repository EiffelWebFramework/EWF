note
	description: "[
				Main interface to send message back to the client
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_RESPONSE

create {WSF_SERVICE}
	make_from_wgi

convert
	make_from_wgi ({WGI_RESPONSE})

feature {NONE} -- Initialization

	make_from_wgi (r: WGI_RESPONSE)
		do
			wgi_response := r
		end

	wgi_response: WGI_RESPONSE
			-- Associated WGI_RESPONSE

feature -- Status report

	status_committed: BOOLEAN
			-- Status line committed?
		do
			Result := wgi_response.status_committed
		end

	header_committed: BOOLEAN
			-- Header committed?
		do
			Result := wgi_response.header_committed
		end

	message_committed: BOOLEAN
			-- Message committed?
		do
			Result := wgi_response.message_committed
		end

	message_writable: BOOLEAN
			-- Can message be written?
		do
			Result := wgi_response.message_writable
		end

feature -- Status setting

	status_is_set: BOOLEAN
			-- Is status set?
		do
			Result := wgi_response.status_is_set
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		require
			status_not_set: not status_committed
			header_not_committed: not header_committed
		do
			wgi_response.set_status_code (a_code)
		ensure
			status_code_set: status_code = a_code
			status_set: status_is_set
		end

	status_code: INTEGER
			-- Response status
		do
			Result := wgi_response.status_code
		end

feature -- Header output operation

	put_header_text (a_headers: READABLE_STRING_8)
		require
			status_set: status_is_set
			header_not_committed: not header_committed
		local
			status_line: STRING
		do
			status_line := {HTTP_HEADER_NAMES}.header_status + ": " + status_code.out + {HTTP_CONSTANTS}.crlf
			wgi_response.put_header_text (status_line + a_headers)
		ensure
			status_set: status_is_set
			header_committed: header_committed
			message_writable: message_writable
		end

	put_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Send headers with status `a_status', and headers from `a_headers'
		require
			status_not_committed: not status_committed
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
		do
			set_status_code (a_status_code)
			if a_headers /= Void then
				create h.make_from_array (a_headers)
				put_header_text (h.string)
			end
		ensure
			header_committed: header_committed
			status_set: status_is_set
			message_writable: message_writable
		end

	put_header_lines (a_lines: ITERABLE [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		do
			wgi_response.put_header_lines (a_lines)
		end

feature -- Output operation

	put_character (c: CHARACTER_8)
			-- Send the string `s'
		require
			message_writable: message_writable
		do
			wgi_response.put_character (c)
		end

	put_string (s: READABLE_STRING_8)
			-- Send the string `s'
		require
			message_writable: message_writable
		do
			wgi_response.put_string (s)
		end

	put_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
			-- Send the substring `s[a_begin_index:a_end_index]'
		require
			message_writable: message_writable
		do
			wgi_response.put_substring (s, a_begin_index, a_end_index)
		end

	put_chunk (s: detachable READABLE_STRING_8; a_extension: detachable READABLE_STRING_8)
			-- Write chunk `s'
			-- If s is Void, this means this was the final chunk
			-- Note: that you should have header
			-- "Transfer-Encoding: chunked"
		require
			message_writable: message_writable
			valid_chunk_extension: a_extension /= Void implies not a_extension.has ('%N') and not not a_extension.has ('%R')
		local
			l_chunk_size_line: STRING_8
			i: INTEGER
		do
			if s /= Void then
					--| Remove all left '0'
				l_chunk_size_line := s.count.to_hex_string
				from
					i := 1
				until
					l_chunk_size_line[i] /= '0'
				loop
					i := i + 1
				end
				if i > 1 then
					l_chunk_size_line := l_chunk_size_line.substring (i, l_chunk_size_line.count)
				end

				if a_extension /= Void then
					l_chunk_size_line.append_character (';')
					l_chunk_size_line.append (a_extension)
				end
				l_chunk_size_line.append ({HTTP_CONSTANTS}.crlf)
				put_string (l_chunk_size_line)
				put_string (s)
				put_string ({HTTP_CONSTANTS}.crlf)
			else
				put_string ("0" + {HTTP_CONSTANTS}.crlf)
			end
			flush
		end

	put_chunk_end
			-- Put end of chunked content
		do
			put_chunk (Void, Void)
		end

	flush
			-- Flush if it makes sense
		do
			wgi_response.flush
		end

feature -- Response object

	put_response (obj: WSF_RESPONSE_MESSAGE)
			-- Set `obj' as the whole response to the client
			--| `obj' is responsible to sent the status code, the header and the content
		require
			header_not_committed: not header_committed
			status_not_committed: not status_committed
			no_message_committed: not message_committed
		do
			obj.send_to (Current)
		ensure
			status_committed: status_committed
			header_committed: header_committed
		end

feature -- Redirect

	redirect_now_custom (a_url: READABLE_STRING_8; a_status_code: INTEGER; a_header: detachable HTTP_HEADER; a_content: detachable TUPLE [body: READABLE_STRING_8; type: READABLE_STRING_8])
			-- Redirect to the given url `a_url' and precise custom `a_status_code', custom header and content
			-- Please see http://www.faqs.org/rfcs/rfc2616 to use proper status code.
			-- if `a_status_code' is 0, use the default {HTTP_STATUS_CODE}.temp_redirect
		require
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
		do
			if header_committed then
				-- This might be a trouble about content-length
				put_string ("Headers already sent.%NCannot redirect, for now please follow this <a %"href=%"" + a_url + "%">link</a> instead%N")
			else
				if a_header /= Void then
					create h.make_from_header (a_header)
				else
					create h.make_with_count (1)
				end
				h.put_location (a_url)
				if a_status_code = 0 then
					set_status_code ({HTTP_STATUS_CODE}.temp_redirect)
				else
					set_status_code (a_status_code)
				end
				if a_content /= Void then
					h.put_content_length (a_content.body.count)
					h.put_content_type (a_content.type)
					put_header_text (h.string)
					put_string (a_content.body)
				else
					h.put_content_length (0)
					put_header_text (h.string)
				end
			end
		end

	redirect_now (a_url: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		require
			header_not_committed: not header_committed
		do
			redirect_now_custom (a_url, {HTTP_STATUS_CODE}.temp_redirect, Void, Void)
		end

	redirect_now_with_content (a_url: READABLE_STRING_8; a_content: READABLE_STRING_8; a_content_type: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		do
			redirect_now_custom (a_url, {HTTP_STATUS_CODE}.temp_redirect, Void, [a_content, a_content_type])
		end

note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
