note
	description: "Summary description for {GW_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_RESPONSE

feature {GW_APPLICATION} -- Commit

	commit (a_output_stream: GW_OUTPUT_STREAM)
			-- Commit the current response
		do
			--| To be redefined as needed, to flush, or what you need...
			a_output_stream.flush
		end

feature {NONE} -- Core output operation

	write (s: STRING)
			-- Send the string `s'
			-- this can be used for header and body
		deferred
		end

feature -- Status setting

	is_status_set: BOOLEAN
		do
			Result := status_code /= 0
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		require
			status_not_set: not is_status_set
		do
			status_code := a_code
			write_status (a_code)
		ensure
			status_set: is_status_set
		end

	status_code: INTEGER
			-- Response status

feature {NONE} -- Status output

	write_status (a_code: INTEGER)
			-- Send status line for `a_code'
		deferred
		ensure
			status_set: is_status_set
		end

feature -- Output operation

	write_string (s: STRING)
			-- Send the string `s'
		require
			status_set: is_status_set
		do
			write (s)
		end

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		require
			status_set: is_status_set
		deferred
		end

feature -- Header output operation

	write_header_object (h: GW_HEADER)
			-- Send `header' to `output'.
		require
			status_set: is_status_set
		deferred
		end

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: STRING; value: STRING]])
			-- Send headers with status `a_status', and headers from `a_headers'
		require
			status_not_set: not is_status_set
		local
			h: GW_HEADER
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
			write_header_object (h)
		ensure
			status_set: is_status_set
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
