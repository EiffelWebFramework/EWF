note
	description: "Summary description for {WGI_CHUNKED_INPUT_STREAM}."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Chunked Transfer Coding", "protocol=URI", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6.1"

class
	WGI_CHUNKED_INPUT_STREAM

inherit
	WGI_INPUT_STREAM

create
	make

feature {NONE} -- Implementation

	make (an_input: like input)
		do
			create last_string.make_empty
			create last_chunk.make_empty
			last_chunk_size := 0
			index := 0
			chunk_lower := 0
			chunk_upper := 0
			create tmp_hex_chunk_size.make_empty
			input := an_input
		end

feature -- Input

	read_character
			-- Read the next character in input stream.
			-- Make the result available in `last_character'
		do
			index := index + 1
			if index > chunk_upper then
				read_chunk
				if last_chunk = Void then
					read_trailer_and_crlf
				end
			end
			last_character := last_chunk.item (index)
		end

	read_string (nb: INTEGER)
			-- Read the next `nb' characters and
			-- make the string result available in `last_string'
			--| Chunked-Body   = *chunk
			--| last-chunk
			--| trailer
			--| CRLF
		local
			i: like index
		do
			last_string.wipe_out
			if last_trailer /= Void then
				-- trailer already reached, no more data
				check input.end_of_input end
			else
				if last_chunk_size = 0 then
					read_chunk
				end
				from
					index := index + 1
					i := index
				until
					i - index + 1 = nb or last_chunk_size = 0
				loop
					if i + nb - 1 <= chunk_upper then
						last_string.append (last_chunk.substring (i - chunk_lower + 1, i - chunk_lower + 1 + nb - 1))
						i := i + nb - 1
					else
						-- Need to read new chunk
						-- first get all available data from current chunk
						if i <= chunk_upper then
							last_string.append (last_chunk.substring (i - chunk_lower + 1, chunk_upper - chunk_lower + 1))
							i := chunk_upper
						end
						-- then continue
						read_chunk
						i := i + 1
						check i = chunk_lower end
					end
				end
				if last_chunk_size = 0 then
					read_trailer_and_crlf
				end
				index := i
			end
		end

feature -- Access

	last_string: STRING_8
			-- Last string read.
			--
			-- Note: this query *might* return the same object.
			-- Therefore a clone should be used if the result
			-- is to be kept beyond the next call to this feature.
			-- However `last_string' is not shared between file objects.)

	last_character: CHARACTER_8
			-- Last item read.

	last_trailer: detachable STRING_8
			-- Last trailer content if any.

feature -- Status report

	is_open_read: BOOLEAN
			-- Can items be read from input stream?
		do
			Result := input.is_open_read
		end

	end_of_input: BOOLEAN
			-- Has the end of input stream been reached?
		do
			Result := input.end_of_input
		end

feature {NONE} -- Parser

	index, chunk_lower, chunk_upper: INTEGER
	last_chunk_size: INTEGER
	last_chunk: STRING_8

	tmp_hex_chunk_size: STRING_8

	read_chunk
		local
			l_input: like input
		do
			if input.end_of_input then
			else
				chunk_lower := chunk_upper + 1
				last_chunk.wipe_out
				last_chunk_size := 0
				read_chunk_size
				if last_chunk_size > 0 then
					chunk_upper := chunk_upper + last_chunk_size
					read_chunk_data
					check last_chunk.count = last_chunk_size end

					l_input := input
					l_input.read_character
					check l_input.last_character = '%R' end
					l_input.read_character
					check l_input.last_character = '%N' end
				end
			end
		ensure
			attached last_chunk as l_last_chunk implies l_last_chunk.count = chunk_upper - chunk_lower
		end

	read_chunk_data
		require
			last_chunk.is_empty
			last_chunk_size > 0
		local
			l_input: like input
		do
			debug ("wgi")
				print (" Read chunk data ("+ last_chunk_size.out +") %N")
			end
			l_input := input
			l_input.read_string (last_chunk_size)
			last_chunk := l_input.last_string
		ensure
			last_chunk_attached: attached last_chunk as el_last_chunk
			last_chunk_size_ok: el_last_chunk.count = last_chunk_size
		end

	read_chunk_size
		require
			tmp_hex_chunk_size_is_empty: tmp_hex_chunk_size.is_empty
		local
			eol : BOOLEAN
			c: CHARACTER
			hex : HEXADECIMAL_STRING_TO_INTEGER_CONVERTER
			l_input: like input
		do
			debug ("wgi")
				print (" Read chunk size: ")
			end

			l_input := input
			from
				l_input.read_character
			until
				eol
			loop
				c := l_input.last_character
				debug ("wgi")
					print (c.out)
				end
				inspect c
				when '%R' then
					-- We are in the end of the line, we need to read the next character to start the next line.
					eol := True
					l_input.read_character
				when ';' then
					-- We are in an extension chunk data
					read_extension_chunk
				else
					tmp_hex_chunk_size.append_character (c)
					l_input.read_character
				end
			end
			if tmp_hex_chunk_size.same_string ("0") then
				last_chunk_size := 0
			else
				create hex.make
				hex.parse_string_with_type (tmp_hex_chunk_size, hex.type_integer)
				if hex.parse_successful then
					last_chunk_size := hex.parsed_integer
				else
					last_chunk_size := 0 -- ERROR ...
				end
			end
			tmp_hex_chunk_size.wipe_out

			debug ("wgi")
				print ("%N Chunk size = " + last_chunk_size.out + "%N")
			end
		end

	read_extension_chunk
		local
			l_input: like input
		do
			l_input := input
			debug ("wgi")
				print (" Reading extension chunk ")
			end
			from
				l_input.read_character
			until
				l_input.last_character = '%R'
			loop
				debug ("wgi")
					print (l_input.last_character)
				end
				l_input.read_character
			end
		end

	read_trailer_and_crlf
			-- trailer        = *(entity-header CRLF)
			-- CRLF
		local
			l_input: like input
			l_line_size: INTEGER
			s: STRING_8
		do
			create s.make_empty
			l_input := input
			if not l_input.end_of_input then
				debug ("wgi")
					print (" Reading trailer ")
				end
				from
					l_line_size := 1 -- Dummy value /= 0
				until
					l_line_size = 0
				loop
					l_line_size := 0
					from
						l_input.read_character
						s.append_character (l_input.last_character)
					until
						l_input.last_character = '%R'
					loop
						l_line_size := l_line_size + 1
						debug ("wgi")
							print (l_input.last_character)
						end
						l_input.read_character
						s.append_character (l_input.last_character)
					end
					s.remove_tail (1)
					-- read the LF
					l_input.read_character
					check l_input.last_character = '%N' end
				end
			end
			last_trailer := s
		end

feature {NONE} -- Implementation

	input: WGI_INPUT_STREAM
			-- Input Stream

;note
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
