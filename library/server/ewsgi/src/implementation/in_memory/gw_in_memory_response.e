note
	description: "Summary description for {GW_IN_MEMORY_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_IN_MEMORY_RESPONSE

inherit
	GW_RESPONSE
		redefine
			commit
		end

create {GW_APPLICATION}
	make

feature {NONE} -- Initialization

	make
		do
			create header.make
			create body.make (100)
		end

	header: GW_HEADER

	body: STRING_8

feature {NONE} -- Status output

	write (s: STRING)
			-- Send the content of `s'
		do
			body.append (s)
		end

feature -- Status setting

	is_status_set: BOOLEAN
		do
			Result := status_code /= 0
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		do
			status_code := a_code
		end

	status_code: INTEGER
			-- Response status		

feature -- Output operation

	write_string (s: STRING)
			-- Send the string `s'
		do
			write (s)
		end

	write_file_content (fn: STRING)
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
					write (f.last_string)
				end
				f.close
			end
		end

feature -- Header output operation		

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: STRING; value: STRING]])
			-- Send headers with status `a_status', and headers from `a_headers'
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
			header := h
		end

feature {GW_APPLICATION} -- Commit

	commit (a_output: GW_OUTPUT_STREAM)
		do
			a_output.put_status_line (status_code)
			a_output.put_string (header.string)
			a_output.put_string (body)
			a_output.flush
		end

;note
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
