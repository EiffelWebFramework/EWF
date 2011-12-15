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
	make ( an_input : like input)
		do
			create last_chunked.make_empty
			create last_chunk_size.make_empty
			input := an_input
		end

feature --Input
	read
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
			eoc : BOOLEAN
		do
			from
				read_chunk
				last_chunked.append (input.last_string)
				if last_chunk_size.is_equal ("0") then
					eoc := true
				end
			until
				eoc
			loop
				read_chunk
				last_chunked.append (input.last_string)
				if last_chunk_size.is_equal ("0") then
					eoc := true
				end
			end

			read_trailer

		end

feature {NONE} -- Parser
	last_chunk_size : STRING

	read_chunk
		do
			-- clear last results
			last_chunk_size.wipe_out

			-- new read
			read_chunk_size
			read_chunk_data
		end

	read_chunk_data
		local
			hex : HEXADECIMAL_STRING_TO_INTEGER_CONVERTER
		do
			create hex.make
			hex.parse_string_with_type (last_chunk_size, hex.type_integer)
			if hex.parse_successful then
				input.read_string (hex.parsed_integer)
			end
			-- read CRLF
			input.read_character
			if input.last_character.is_equal ('%R') then
				input.read_character
			end
		end

	read_chunk_size
		local
			eol : BOOLEAN
		do
			from
				input.read_character
			until
				eol
			loop

				if input.last_character.is_equal ('%R') then
					-- We are in the end of the line, we need to read the next character to start the next line.
					input.read_character
					eol := true
				elseif input.last_character.is_equal (';') then
					-- We are in an extension chunk data
					read_extension_chunk
				else
					last_chunk_size.append_character (input.last_character)
					input.read_character
				end
			end
		end

	read_extension_chunk
		do
			print (" Reading extension chunk ")
			from
				input.read_character
			until
				input.last_character.is_equal ('%R')
			loop
				print (input.last_character)
				input.read_character
			end
		end

	read_trailer
		do
			if not input.end_of_input then
				print (" Reading trailer ")
				from
					input.read_character
				until
					input.last_character.is_equal ('%R')
				loop
					print (input.last_character)
					input.read_character
				end
				-- read the LF
				input.read_character
			end
		end
feature {NONE} -- Access

	input: WGI_INPUT_STREAM
		-- Input Stream

feature -- Access		
	last_chunked: STRING_8

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
