note
	description: "Summary description for {WGI_CHUNKED_INPUT_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_CHUNKED_INPUT_STREAM

create
	make

feature {NONE} -- Implementation

	make (an_input: like input)
		do
			create tmp_hex_chunk_size.make_empty
			input := an_input
		end

feature -- Input

	data: STRING_8
		local
			d: like internal_data
		do
			d := internal_data
			if d = Void then
				d := fetched_data
				internal_data := d
			end
			Result := d
		end

feature {NONE} -- Parser

	internal_data: detachable STRING_8

	tmp_hex_chunk_size: STRING_8
	last_chunk_size: INTEGER
	last_chunk: detachable STRING_8

	fetched_data: STRING_8
			-- Read all the data in a chunked stream.
			-- Make the result available in `last_chunked'.
			--	   Chunked-Body   = *chunk
			--                        last-chunk
			--                        trailer
			--                        CRLF
			--       chunk          = chunk-size [ chunk-extension ] CRLF
			--                        chunk-data CRLF
			--       chunk-size     = 1*HEX
			--       last-chunk     = 1*("0") [ chunk-extension ] CRLF
			--       chunk-extension= *( ";" chunk-ext-name [ "=" chunk-ext-val ] )
			--       chunk-ext-name = token
			--       chunk-ext-val  = token | quoted-string
			--       chunk-data     = chunk-size(OCTET)
			--       trailer        = *(entity-header CRLF)
		local
			eoc: BOOLEAN
			s: STRING_8
		do
			from
				create s.make (1024)
			until
				eoc
			loop
				read_chunk
				if attached last_chunk as l_last_chunk then
					s.append (l_last_chunk)
				else
					eoc := True
				end
				if last_chunk_size = 0 then
					eoc := True
				end
			end

			read_trailer

			Result := s
		end

	reset_chunk
		do
			last_chunk := Void
			last_chunk_size := 0
		end

	read_chunk
		do
			reset_chunk
			read_chunk_size
			if last_chunk_size > 0 then
				read_chunk_data
			end
		end

	read_chunk_data
		require
			last_chunk_size > 0
		do
			input.read_string (last_chunk_size)
			last_chunk := input.last_string

			-- read CRLF
			input.read_character
			if input.last_character = '%R' then
				input.read_character
			end
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
		do
			from
				input.read_character
			until
				eol
			loop
				c := input.last_character
				inspect c
				when '%R' then
					-- We are in the end of the line, we need to read the next character to start the next line.
					eol := True
					input.read_character
				when ';' then
					-- We are in an extension chunk data
					read_extension_chunk
				else
					tmp_hex_chunk_size.append_character (c)
					input.read_character
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
		end

	read_extension_chunk
		do
			debug
				print (" Reading extension chunk ")
			end
			from
				input.read_character
			until
				input.last_character = '%R'
			loop
				debug
					print (input.last_character)
				end
				input.read_character
			end
		end

	read_trailer
		do
			if not input.end_of_input then
				debug
					print (" Reading trailer ")
				end
				from
					input.read_character
				until
					input.last_character = '%R'
				loop
					debug
						print (input.last_character)
					end
					input.read_character
				end
				-- read the LF
				input.read_character
			end
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
