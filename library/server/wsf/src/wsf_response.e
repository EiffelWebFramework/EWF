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

	write_headers_string (a_headers: READABLE_STRING_8)
		require
			status_set: status_is_set
			header_not_committed: not header_committed
		do
			wgi_response.write_headers (a_headers)
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
			wgi_response.write_headers (h.string)
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
