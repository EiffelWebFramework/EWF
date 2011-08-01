note
	description: "Summary description for {GW_BUFFERED_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_BUFFERED_RESPONSE

inherit
	EWSGI_RESPONSE_BUFFER
		rename
			make as buffer_make
		redefine
			write,
			flush,
			commit
		end

create {EWSGI_APPLICATION}
	make

feature {NONE} -- Initialization

	make (a_output: like output; a_buffer_size: INTEGER)
		do
			buffer_make (a_output)
			buffer_capacity := a_buffer_size
			create buffer.make (a_buffer_size)
		end

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
			output.put_string (buffer)
			buffer_count := 0
		ensure
			buffer_flushed: buffer_count = 0 and buffer.count = 0
		end

feature {EWSGI_APPLICATION} -- Commit

	commit
		do
			flush_buffer
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
