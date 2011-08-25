note
	description: "Summary description for {GW_BUFFERED_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_BUFFERED_RESPONSE

inherit
	EWSGI_RESPONSE_BUFFER

create {EWSGI_APPLICATION}
	make

feature {NONE} -- Initialization

	make (a_res: like response_buffer; a_buffer_size: INTEGER)
		do
			response_buffer := a_res
			buffer_capacity := a_buffer_size
			create buffer.make (a_buffer_size)
		end

	response_buffer: EWSGI_RESPONSE_BUFFER

	buffer: STRING_8

	buffer_capacity: INTEGER

	buffer_count: INTEGER

feature {NONE} -- Core output operation

	write (s: STRING)
			-- Send the content of `s'
		local
			buf: like buffer
			len_b, len_s: INTEGER
		do
			buf := buffer
			len_s := s.count
			len_b := buffer_count
			if len_b + len_s >= buffer_capacity then
				flush_buffer
				if len_s >= buffer_capacity then
						-- replace buffer by `s'
					buffer := s
					buffer_count := len_s
					flush_buffer
						-- restore buffer with `buf'
					buffer := buf
				else
					buf.append (s)
					buffer_count := len_s
				end
			else
				buf.append (s)
				buffer_count := len_b + len_s
			end
		end

feature -- Output operation

	flush
		do
			flush_buffer
		end

feature {NONE} -- Implementation

	flush_buffer
		require
			buffer_count_match_buffer: buffer_count = buffer.count
		do
			response_buffer.write (buffer)
			buffer_count := 0
		ensure
			buffer_flushed: buffer_count = 0 and buffer.count = 0
		end

feature {EWSGI_APPLICATION} -- Commit

	commit
		do
			flush_buffer
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
			response_buffer.set_status_code (a_code)
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
			flush_buffer
			response_buffer.write_substring (s, start_index, end_index)
		end

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		do
			flush_buffer
			response_buffer.write_file_content (fn)
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
