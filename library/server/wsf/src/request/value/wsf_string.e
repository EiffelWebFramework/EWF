note
	description: "[
				{WSF_STRING} represents a String parameter
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STRING

inherit
	WSF_VALUE
		redefine
			same_string,
			is_case_insensitive_equal
		end

create
	make,
	make_with_percent_encoded_values

convert
	string_representation: {READABLE_STRING_32, STRING_32}

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL; a_string: READABLE_STRING_GENERAL)
		do
			url_encoded_name := url_encoded_string (a_name)
			url_encoded_value := url_encoded_string (a_string)
		end

	make_with_percent_encoded_values (a_encoded_name: READABLE_STRING_8; a_encoded_value: READABLE_STRING_8)
		do
			url_encoded_name := a_encoded_name
			url_encoded_value := a_encoded_value
		end

feature -- Access

	name: READABLE_STRING_32
			-- <Precursor>
			--| Note that the value might be html encoded as well
			--| this is the application responsibility to html decode it
		local
			v: like internal_name
		do
			v := internal_name
			if v = Void then
				v := url_decoded_string (url_encoded_name)
				internal_name := v
			end
			Result := v
		end

	value: READABLE_STRING_32
			-- <Precursor>
			--| Note that the value might be html encoded as well
			--| this is the application responsibility to html decode it
		local
			v: like internal_value
		do
			v := internal_value
			if v = Void then
				v := url_decoded_string (url_encoded_value)
				internal_value := v
			end
			Result := v
		end

	url_encoded_name: READABLE_STRING_8
			-- URL encoded string of `name'.

	url_encoded_value: READABLE_STRING_8
			-- URL encoded string of `value'.

feature {NONE} -- Access: internals

	internal_name: detachable like name
			-- Cached value of `name'.		

	internal_value: detachable like value
			-- Cached value of `value'.

feature -- Conversion

	integer_value: INTEGER
			-- Integer value of `value'.
		require
			value_is_integer: is_integer
		do
			Result := value.to_integer
		end

feature -- Status report

	is_string: BOOLEAN = True
			-- Is Current as a WSF_STRING representation?

	is_empty: BOOLEAN
			-- Is empty?
		do
			Result := value.is_empty
		end

	is_integer: BOOLEAN
			-- Is `value' an integer?
		do
			Result := value.is_integer
		end

feature -- Element change

	change_name (a_name: like name)
			-- <Precursor>
		do
			internal_name := a_name
			url_encoded_name := url_encoded_string (a_name)
		end

feature -- Helper

	same_string (a_other: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_other' represent the same string as `Current'?	
		do
			Result := value.same_string_general (a_other)
		end

	is_case_insensitive_equal (a_other: READABLE_STRING_8): BOOLEAN
			-- Does `a_other' represent the same case insensitive string as `Current'?
		local
			v: like value
		do
			v := value
			if v = a_other then
				Result := True
			elseif v.is_valid_as_string_8 then
				Result := v.is_case_insensitive_equal (a_other)
			end
		end

feature -- Conversion

	string_representation: STRING_32
		do
			create Result.make_from_string (value)
		end

feature -- Visitor

	process (vis: WSF_VALUE_VISITOR)
		do
			vis.process_string (Current)
		end

--feature {NONE} -- Implementation

--	utf_8_percent_encoded_string (s: READABLE_STRING_GENERAL): READABLE_STRING_8
--			-- Percent-encode the UTF-8 sequence characters from UTF-8 encoded `s' and
--			-- return the Result.
--		local
--			s8: STRING_8
--			i, n, nb: INTEGER
--		do
--				-- First check if there are such UTF-8 character
--				-- If it has, convert them and return a new object as Result
--				-- otherwise return `s' directly to avoid creating a new object
--			from
--				i := 1
--				n := s.count
--				nb := 0
--			until
--				i > n
--			loop
--				if s.code (i) > 0x7F then -- >= 128
--					nb := nb + 1
--				end
--				i := i + 1
--			end
--			if nb > 0 then
--				create s8.make (s.count + nb * 3)
--				utf_8_string_into_percent_encoded_string_8 (s, s8)
--				Result := s8
--			else
--				Result := s.to_string_8
--			end
--		end

--	utf_8_string_into_percent_encoded_string_8 (s: READABLE_STRING_GENERAL; a_result: STRING_8)
--			-- Copy STRING_32 corresponding to UTF-8 sequence `s' appended into `a_result'.
--		local
--			i: INTEGER
--			n: INTEGER
--			c: NATURAL_32
--		do
--			from
--				n := s.count
--				a_result.grow (a_result.count + n)
--			until
--				i >= n
--			loop
--				i := i + 1
--				c := s.code (i)
--				if c <= 0x7F then
--						-- 0xxxxxxx
--					a_result.append_code (c)
--				elseif c <= 0xDF then
--						-- 110xxxxx 10xxxxxx
--					url_encoder.append_percent_encoded_character_code_to (c, a_result)
--					i := i + 1
--					if i <= n then
--						url_encoder.append_percent_encoded_character_code_to  (s.code (i), a_result)
--					end
--				elseif c <= 0xEF then
--						-- 1110xxxx 10xxxxxx 10xxxxxx
--					url_encoder.append_percent_encoded_character_code_to  (s.code (i), a_result)
--					i := i + 2
--					if i <= n then
--						url_encoder.append_percent_encoded_character_code_to  (s.code (i - 1), a_result)
--						url_encoder.append_percent_encoded_character_code_to  (s.code (i), a_result)
--					end
--				elseif c <= 0xF7 then
--						-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
--					url_encoder.append_percent_encoded_character_code_to  (s.code (i), a_result)
--					i := i + 3
--					if i <= n then
--						url_encoder.append_percent_encoded_character_code_to  (s.code (i - 2), a_result)
--						url_encoder.append_percent_encoded_character_code_to  (s.code (i - 1), a_result)
--						url_encoder.append_percent_encoded_character_code_to  (s.code (i), a_result)
--					end
--				else
--						-- FIXME: unicode character, first utf8 it, then percent encode it.
--					append_percent_encoded_unicode_character_code_to (c, a_result)
----					a_result.append_code (c)
--				end
--			end
--		end

--	append_percent_encoded_ascii_character_code_to (a_code: NATURAL_32; a_result: STRING_GENERAL)
--			-- Append extended ascii character code `a_code' as percent-encoded content into `a_result'
--			-- Note: it does not UTF-8 convert this extended ASCII.
--		require
--			is_extended_ascii: a_code <= 0xFF
--		local
--			c: INTEGER
--		do
--			if a_code > 0xFF then
--				-- Unicode
--				append_percent_encoded_unicode_character_code_to (a_code, a_result)
--			else
--				-- Extended ASCII
--				c := a_code.to_integer_32
--				a_result.append_code (37) -- 37 '%%'
--	 			a_result.append_code (hex_digit [c |>> 4])
--	 			a_result.append_code (hex_digit [c & 0xF])
--			end
--		ensure
--			appended: a_result.count > old a_result.count
--		end

--	append_percent_encoded_unicode_character_code_to (a_code: NATURAL_32; a_result: STRING_GENERAL)
--			-- Append Unicode character code `a_code' as UTF-8 and percent-encoded content into `a_result'
--			-- Note: it does include UTF-8 conversion of extended ASCII and Unicode.
--		do
--			if a_code <= 0x7F then
--					-- 0xxxxxxx
--				append_percent_encoded_ascii_character_code_to (a_code, a_result)
--			elseif a_code <= 0x7FF then
--					-- 110xxxxx 10xxxxxx
--				append_percent_encoded_ascii_character_code_to ((a_code |>> 6) | 0xC0, a_result)
--				append_percent_encoded_ascii_character_code_to ((a_code & 0x3F) | 0x80, a_result)
--			elseif a_code <= 0xFFFF then
--					-- 1110xxxx 10xxxxxx 10xxxxxx
--				append_percent_encoded_ascii_character_code_to ((a_code |>> 12) | 0xE0, a_result)
--				append_percent_encoded_ascii_character_code_to (((a_code |>> 6) & 0x3F) | 0x80, a_result)
--				append_percent_encoded_ascii_character_code_to ((a_code & 0x3F) | 0x80, a_result)
--			else
--					-- c <= 1FFFFF - there are no higher code points
--					-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
--				append_percent_encoded_ascii_character_code_to ((a_code |>> 18) | 0xF0, a_result)
--				append_percent_encoded_ascii_character_code_to (((a_code |>> 12) & 0x3F) | 0x80, a_result)
--				append_percent_encoded_ascii_character_code_to (((a_code |>> 6) & 0x3F) | 0x80, a_result)
--				append_percent_encoded_ascii_character_code_to ((a_code & 0x3F) | 0x80, a_result)
--			end
--		ensure
--			appended: a_result.count > old a_result.count
--		end

-- 	hex_digit: SPECIAL [NATURAL_32]
-- 			-- Hexadecimal digits.
-- 		once
-- 			create Result.make_filled (0, 16)
-- 			Result [0] := {NATURAL_32} 48 -- 48 '0'
-- 			Result [1] := {NATURAL_32} 49 -- 49 '1'
-- 			Result [2] := {NATURAL_32} 50 -- 50 '2'
-- 			Result [3] := {NATURAL_32} 51 -- 51 '3'
-- 			Result [4] := {NATURAL_32} 52 -- 52 '4'
-- 			Result [5] := {NATURAL_32} 53 -- 53 '5'
-- 			Result [6] := {NATURAL_32} 54 -- 54 '6'
-- 			Result [7] := {NATURAL_32} 55 -- 55 '7'
-- 			Result [8] := {NATURAL_32} 56 -- 56 '8'
-- 			Result [9] := {NATURAL_32} 57 -- 57 '9'
-- 			Result [10] := {NATURAL_32} 65 -- 65 'A'
-- 			Result [11] := {NATURAL_32} 66 -- 66 'B'
-- 			Result [12] := {NATURAL_32} 67 -- 67 'C'
-- 			Result [13] := {NATURAL_32} 68 -- 68 'D'
-- 			Result [14] := {NATURAL_32} 69 -- 69 'E'
-- 			Result [15] := {NATURAL_32} 70 -- 70 'F'
-- 		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
