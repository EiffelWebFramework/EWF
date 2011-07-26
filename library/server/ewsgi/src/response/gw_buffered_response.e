note
	description: "Summary description for {GW_BUFFERED_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_BUFFERED_RESPONSE

inherit
	GW_RESPONSE
		redefine
			commit
		end

create {GW_APPLICATION}
	make

feature {NONE} -- Initialization

	make (a_output: like output; a_buffer_size: INTEGER)
		do
			output := a_output
			buffer_capacity := a_buffer_size
			create buffer.make (a_buffer_size)
		end

	output: GW_OUTPUT_STREAM

	buffer: STRING_8

	buffer_capacity: INTEGER

	buffer_count: INTEGER

feature -- Status setting

	set_status_code (c: INTEGER)
			-- Set the status code of the response
		do
			header.put_status (c)
		end

feature -- Output operation

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

	write_header_object (h: GW_HEADER)
			-- Send `header' to `output'.
		do
			header := h
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

feature {GW_APPLICATION} -- Commit

	commit (a_output: GW_OUTPUT_STREAM)
		do
			flush_buffer
			Precursor (a_output)
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
