note
	description : "[
			Objects that represents the output stream
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_OUTPUT_STREAM

feature -- Core operation

	put_string (s: STRING_8)
			-- Write `s' into the output stream
		require
			s_not_empty: s /= Void and then not s.is_empty
		deferred
		end

	flush
			-- Flush the output stream	
		do
		end

feature -- Basic operation

	put_file_content (fn: STRING)
			-- Send the content of file `fn'
		local
			f: RAW_FILE
		do
			create f.make (fn)
			if f.exists and then f.is_readable then
				f.open_read
				from
				until
					f.exhausted
				loop
					f.read_stream (1024)
					put_string (f.last_string)
				end
				f.close
			end
		end

	put_header (a_status: INTEGER; a_headers: ARRAY [TUPLE [key: STRING; value: STRING]])
			-- Send headers with status `a_status', and headers from `a_headers'
		local
			h: GW_HEADER
			i,n: INTEGER
		do
			create h.make
			h.put_status (a_status)
			from
				i := a_headers.lower
				n := a_headers.upper
			until
				i > n
			loop
				h.put_header_key_value (a_headers[i].key, a_headers[i].value)
				i := i + 1
			end
			put_string (h.string)
		end

	put_header_line (s: STRING)
			-- Send `s' to http client as header line
		do
			put_string (s)
			put_string ("%R%N")
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
