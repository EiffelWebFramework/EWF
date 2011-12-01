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
			status_not_set: not status_is_set
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

	write_header_text (a_headers: READABLE_STRING_8)
		require
			status_set: status_is_set
			header_not_committed: not header_committed
		do
			wgi_response.write_header_text (a_headers)
		ensure
			status_set: status_is_set
			header_committed: header_committed
			message_writable: message_writable
		end

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Send headers with status `a_status', and headers from `a_headers'
		require
			status_not_set: not status_is_set
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
			i,n: INTEGER
		do
			set_status_code (a_status_code)
			create h.make
			if a_headers /= Void then
				from
					i := a_headers.lower
					n := a_headers.upper
				until
					i > n
				loop
					h.put_header_key_value (a_headers[i].key, a_headers[i].value)
					i := i + 1
				end
			end
			wgi_response.write_header_text (h.string)
		ensure
			header_committed: header_committed
			status_set: status_is_set
			message_writable: message_writable
		end

feature -- Output operation

	write_string (s: READABLE_STRING_8)
			-- Send the string `s'
		require
			message_writable: message_writable
		do
			wgi_response.write_string (s)
		end

	write_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
			-- Send the substring `s[a_begin_index:a_end_index]'
		require
			message_writable: message_writable
		do
			wgi_response.write_substring (s, a_begin_index, a_end_index)
		end

	write_chunk (s: detachable READABLE_STRING_8)
			-- Write chunk `s'
			-- If s is Void, this means this was the final chunk
			-- Note: that you should have header
			-- "Transfer-Encoding: chunked"
		local
			hex: STRING
			i: INTEGER
		do
			if s /= Void then
					--| Remove all left '0'
				hex := s.count.to_hex_string
				from
					i := 1
				until
					hex[i] /= '0'
				loop
					i := i + 1
				end
				if i > 1 then
					hex := hex.substring (i, hex.count)
				end
				write_string (hex + {HTTP_CONSTANTS}.crlf)
				write_string (s)
				write_string ({HTTP_CONSTANTS}.crlf)
			else
				write_string ("0" + {HTTP_CONSTANTS}.crlf)
			end
			flush
		end

	write_file_content (fn: READABLE_STRING_8)
			-- Send the content of file `fn'
		require
			message_writable: message_writable
		do
			wgi_response.write_file_content (fn)
		end

	flush
			-- Flush if it makes sense
		do
			wgi_response.flush
		end

feature -- Helper

	redirect_now_with_custom_status_code (a_url: READABLE_STRING_8; a_status_code: INTEGER)
			-- Redirect to the given url `a_url' and precise custom `a_status_code'
			-- Please see http://www.faqs.org/rfcs/rfc2616 to use proper status code.
		require
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
		do
			if header_committed then
				write_string ("Headers already sent.%NCannot redirect, for now please follow this <a %"href=%"" + a_url + "%">link</a> instead%N")
			else
				create h.make_with_count (1)
				h.put_location (a_url)
				set_status_code (a_status_code)
				write_header_text (h.string)
			end
		end

	redirect_now (a_url: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		require
			header_not_committed: not header_committed
		do
			redirect_now_with_custom_status_code (a_url, {HTTP_STATUS_CODE}.moved_permanently)
		end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
