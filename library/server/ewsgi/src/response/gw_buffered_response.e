note
	description: "Summary description for {GW_BUFFERED_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_BUFFERED_RESPONSE

inherit
	EWSGI_RESPONSE_STREAM

create {EWSGI_APPLICATION}
	make

feature {NONE} -- Initialization

	make (a_output: like output; a_buffer_size: INTEGER)
		do
			output := a_output
			buffer_capacity := a_buffer_size
			create buffer.make (a_buffer_size)
		end

	output: EWSGI_OUTPUT_STREAM

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
			output.put_status_line (status_code)
			--| We could also just append it to the `buffer'
		end

	status_code: INTEGER
			-- Response status	

feature -- Output operation

	flush
		do
			flush_buffer
		end

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
					f.read_stream (buffer_capacity)
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
			write (h.string)
		end


feature {NONE} -- Implementation

	flush_buffer
		require
			buffer_count_match_buffer: buffer_count = buffer.count
		do
			output.put_string (buffer)
			buffer_count := 0
		ensure
			buffer_flushed: buffer_count = 0 and buffer.count = 0
		end

feature {EWSGI_APPLICATION} -- Commit

	commit (a_output: EWSGI_OUTPUT_STREAM)
		do
			flush_buffer
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
