note
	description: "Summary description for {GW_RESPONSE_STREAM_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_RESPONSE_STREAM_IMP

inherit
	EWSGI_RESPONSE_STREAM

create {EWSGI_APPLICATION}
	make

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			output := a_output
		end

feature {EWSGI_APPLICATION} -- Commit

	commit (a_output_stream: EWSGI_OUTPUT_STREAM)
			-- Commit the current response
		do
			a_output_stream.flush
		end

feature {NONE} -- Core output operation

	write (s: STRING)
			-- Send the content of `s'
		do
			output.put_string (s)
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
			output.put_status_line (a_code)
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
		do
			output.put_file_content (fn)
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
			write (h.string)
		end

feature {NONE} -- Implementation: Access

	output: EWSGI_OUTPUT_STREAM
			-- Server output channel

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
