note
	description: "[
			Response buffer

		]"
	specification: "EWSGI specification https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki/EWSGI-specification"
	date: "$Date$"
	revision: "$Revision$"

class
	EWSGI_RESPONSE_STREAM_BUFFER

inherit
	EWSGI_RESPONSE_BUFFER

create
	make

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			output := a_output
		end

feature {EWSGI_APPLICATION} -- Commit

	commit
			-- Commit the current response
		do
			output.flush
			message_committed := True
		end

feature -- Status report

	header_committed: BOOLEAN
			-- Header committed?

	message_committed: BOOLEAN
			-- Message committed?

	message_writable: BOOLEAN
			-- Can message be written?
		do
			Result := status_is_set and header_committed
		end

feature {NONE} -- Core output operation

	write (s: STRING)
			-- Send the content of `s'
			-- this can be used for header and body			
		do
			output.put_string (s)
		end

feature -- Status setting

	status_is_set: BOOLEAN
			-- Is status set?	
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

feature -- Header output operation		

	write_headers_string (a_headers: STRING)
		do
			write (a_headers)
			header_committed := True
		end

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: STRING; value: STRING]])
			-- Send headers with status `a_status', and headers from `a_headers'
		local
			h: GW_HEADER
			i,n: INTEGER
		do
			set_status_code (a_status_code)
			create h.make
			h.put_status (a_status_code)
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
			write_headers_string (h.string)
		end

feature -- Output operation

	write_string (s: STRING)
			-- Send the string `s'
		do
			write (s)
		end

	write_substring (s: STRING; start_index, end_index: INTEGER)
			-- Send the substring `start_index:end_index]'
			--| Could be optimized according to the target output
		do
			output.put_substring (s, start_index, end_index)
		end

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		do
			output.put_file_content (fn)
		end

	flush
		do
			output.flush
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
