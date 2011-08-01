note
	description: "Summary description for {GW_IN_MEMORY_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_IN_MEMORY_RESPONSE

inherit
	EWSGI_RESPONSE_BUFFER
		redefine
			make,
			commit,
			write,
			set_status_code,
			write_header,
			flush
		end

create {EWSGI_APPLICATION}
	make

feature {NONE} -- Initialization

	make (a_output: EWSGI_OUTPUT_STREAM)
		do
			Precursor (a_output)
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

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		do
			status_code := a_code
		end

feature -- Output operation

	flush
		do
			--| Do nothing ... this is in_memory response
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

feature {EWSGI_APPLICATION} -- Commit

	commit
		local
			o: like output
		do
			o := output
			o.put_status_line (status_code)
			o.put_string (header.string)
			header_committed := True
			o.put_string (body)
			o.flush
			Precursor
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
