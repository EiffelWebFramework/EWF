note
	description : "[
			Objects that represents the output stream
		]"
	specification: "EWSGI/connector specification https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki/EWSGI-specification"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_OUTPUT_STREAM

feature -- Output

	put_string (a_string: STRING_8)
			-- Write `a_string' to output stream.
		require
			is_open_write: is_open_write
			a_string_not_void: a_string /= Void
		deferred
		end

	put_substring (a_string: STRING; s, e: INTEGER)
			-- Write substring of `a_string' between indexes
			-- `s' and `e' to output stream.
			--| Could be redefined for optimization			
		require
			is_open_write: is_open_write
			a_string_not_void: a_string /= Void
			s_large_enough: s >= 1
			e_small_enough: e <= a_string.count
			valid_interval: s <= e + 1
		do
			if s <= e then
				put_string (a_string.substring (s, e))
			end
		end

	put_character_8 (c: CHARACTER_8)
			-- Write `c' to output stream.
			--| Could be redefined for optimization			
		require
			is_open_write: is_open_write
		do
			put_string (c.out)
		end

	put_file_content (fn: STRING)
			-- Send the content of file `fn'
		require
			string_not_empty: not fn.is_empty
			is_readable: (create {RAW_FILE}.make (fn)).is_readable
		local
			f: RAW_FILE
		do
			create f.make (fn)
			check f.exists and then f.is_readable end

			f.open_read
			from
			until
				f.exhausted
			loop
				f.read_stream (4096)
				put_string (f.last_string)
			end
			f.close
		end

feature -- Specific output

	put_header_line (s: STRING)
			-- Send `s' to http client as header line
		do
			put_string (s)
			put_string ("%R%N")
		end

feature -- Status writing

	put_status_line (a_code: INTEGER)
			-- Put status code line for `a_code'
			--| Note this is a default implementation, and could be redefined
			--| for instance in relation to NPH CGI script
		deferred
		end

feature -- Status report

	is_open_write: BOOLEAN
			-- Can items be written to output stream?
		deferred
		end

feature -- Basic operations

	flush
			-- Flush buffered data to disk.
		require
			is_open_write: is_open_write
		deferred
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
