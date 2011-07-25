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

feature -- Output operation

	write_string (s: STRING)
			-- Send the content of `s'
		deferred
		end

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		deferred
		end

	write_header_object (h: GW_HEADER)
			-- Send `header' to `output'.
		deferred
		end

	write_header (a_status: INTEGER; a_headers: detachable ARRAY [TUPLE [key: STRING; value: STRING]])
			-- Send headers with status `a_status', and headers from `a_headers'
		local
			h: GW_HEADER
			i,n: INTEGER
		do
			create h.make
			h.put_status (a_status)
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
		end

	write_header_line (s: STRING)
			-- Send `s' to http client as header line
		do
			write_string (s)
			write_string ("%R%N")
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
