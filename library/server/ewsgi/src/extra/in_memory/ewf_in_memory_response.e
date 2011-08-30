note
	description: "Summary description for {EWF_IN_MEMORY_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_IN_MEMORY_RESPONSE

inherit
	WGI_RESPONSE_BUFFER

create {WGI_APPLICATION}
	make

feature {NONE} -- Initialization

	make (res: WGI_RESPONSE_BUFFER)
		do
			response_buffer := res
			create header.make
			create body.make (100)
		end

	response_buffer: WGI_RESPONSE_BUFFER

	header: EWF_HEADER

	body: STRING_8

feature {WGI_APPLICATION} -- Commit

	commit
		local
			r: like response_buffer
		do
			r := response_buffer
			r.set_status_code (status_code)
			r.write_headers_string (header.string)
			header_committed := True
			r.write_string (body)
			r.flush
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
		end

	status_code: INTEGER
			-- Response status		

feature {NONE} -- Status output

	write (s: STRING)
			-- Send the content of `s'
		do
			body.append (s)
		end

feature -- Header output operation	

	write_headers_string (a_headers: STRING)
		do
			write (a_headers)
			header_committed := True
		end

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: STRING; value: STRING]])
			-- Send headers with status `a_status', and headers from `a_headers'
		local
			h: EWF_HEADER
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
			write_string (s.substring (start_index, end_index))
		end

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		do
			response_buffer.write_file_content (fn)
		end

	flush
		do
			--| Do nothing ... this is in_memory response
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
