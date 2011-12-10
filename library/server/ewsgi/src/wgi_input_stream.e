note
	description : "[
			Objects that represents the input stream
		]"
	specification: "EWSGI/connector specification https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki/EWSGI-specification"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_INPUT_STREAM

feature -- Input

	read_character
			-- Read the next character in input stream.
			-- Make the result available in `last_character'.
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
		deferred
		ensure
			same_last_string_reference: last_string = old last_string
		end

	read_string (nb: INTEGER)
		require
			is_open_read: is_open_read
--			not_end_of_input: not end_of_input
			nb_large_enough: nb > 0
		deferred
		ensure
			last_string_count_small_enough: not end_of_input implies last_string.count <= nb
			character_read: not end_of_input implies last_string.count > 0
			same_last_string_reference: last_string = old last_string
		end

	read_to_string (a_string: STRING; pos, nb: INTEGER): INTEGER
			-- Fill `a_string', starting at position `pos', with
			-- at most `nb' characters read from input stream.
			-- Return the number of characters actually read.
			-- (Note that even if at least `nb' characters are available
			-- in the input stream, there is no guarantee that they
			-- will all be read.)
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
			a_string_not_void: a_string /= Void
			valid_position: a_string.valid_index (pos)
			nb_large_enough: nb > 0
			nb_small_enough: nb <= a_string.count - pos + 1
		local
			i, end_pos: INTEGER
		do
			end_pos := pos + nb - 1
			from
				i := pos
			until
				i > end_pos
			loop
				read_character
				if not end_of_input then
					a_string.put (last_character, i)
					i := i + 1
				else
					Result := i - pos - nb
						-- Jump out of the loop.
					i := end_pos + 1
				end
			end
			Result := Result + i - pos
		ensure
			nb_char_read_large_enough: Result >= 0
			nb_char_read_small_enough: Result <= nb
			character_read: not end_of_input implies Result > 0
			same_last_string_reference: last_string = old last_string
		end

feature -- Access

	last_string: STRING_8
			-- Last string read
			-- (Note: this query always return the same object.
			-- Therefore a clone should be used if the result
			-- is to be kept beyond the next call to this feature.
			-- However `last_string' is not shared between file objects.)
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
		deferred
		ensure
			last_string_not_void: Result /= Void
		end

	last_character: CHARACTER_8
			-- Last item read
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
		deferred
		end

feature -- Status report

	is_open_read: BOOLEAN
			-- Can items be read from input stream?
		deferred
		end

	end_of_input: BOOLEAN
			-- Has the end of input stream been reached?
		require
			is_open_read: is_open_read
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
