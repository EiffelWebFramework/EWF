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

	put_character (c: CHARACTER_8)
			-- Write `s' into the output stream
		deferred
		end

	put_string (a_string: READABLE_STRING_8)
			-- Write `a_string' to output stream.
		require
			is_open_write: is_open_write
			a_string_not_void: a_string /= Void
		deferred
		end

	put_substring (a_string: READABLE_STRING_8; s, e: INTEGER)
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

feature -- Specific output

	put_header_line (s: READABLE_STRING_8)
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
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
