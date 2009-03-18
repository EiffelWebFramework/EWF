indexing

	description: "Parse serialized JSON data"
	author: "jvelilla"
	date: "2008/08/24"
	revision: "Revision 0.1"

class
	JSON_PARSER

inherit
	JSON_READER
	JSON_TOKENS

create
	make_parser

feature {NONE} -- Initialize

	make_parser (a_json: STRING) is
			-- Initialize.
		require
			json_not_empty: a_json /= Void and then not a_json.is_empty
		do
			make (a_json)
			is_parsed := True
			create errors.make
		end

feature -- Status report

	is_parsed: BOOLEAN
			-- Is parsed?

	errors: LINKED_LIST [STRING]
			-- Current errors

	current_errors: STRING
			-- Current errors as string
		do
			create Result.make_empty
			from
				errors.start
			until
				errors.after
			loop
				Result.append_string (errors.item + "%N")
				errors.forth
			end
		end

feature -- Element change

	report_error (e: STRING) is
			-- Report error `e'
		require
			e_not_void: e /= Void
		do
			errors.force (e)
		end

feature -- Commands

	parse_json: ?JSON_VALUE is
			-- Parse JSON data `representation'
		do
			Result := parse
			if extra_elements then
				is_parsed := False
			end
		end

	parse: ?JSON_VALUE is
			-- Parse JSON data `representation'
		local
			c: CHARACTER
		do
			if is_parsed then
				skip_white_spaces
				c := actual
				inspect c
				when j_OBJECT_OPEN then
					Result := parse_object
				when j_STRING then
					Result := parse_string
				when j_ARRAY_OPEN then
					Result := parse_array
				else
					if c.is_digit or c = j_MINUS  then
						Result := parse_number
					elseif is_null then
						Result := create {JSON_NULL}
						next
						next
						next
					elseif is_true then
						Result := create {JSON_BOOLEAN}.make_boolean (True)
						next
						next
						next
					elseif is_false then
						Result := create {JSON_BOOLEAN}.make_boolean (False)
						next
						next
						next
						next
					else
						is_parsed := False
						report_error ("JSON is not well formed in parse")
						Result := Void
					end
				end
			end
		ensure
			is_parsed_implies_result_not_void: is_parsed implies Result /= Void
		end

	parse_object: JSON_OBJECT is
			-- object
			-- {}
			-- {"key" : "value" [,]}
		local
			has_more: BOOLEAN
			l_json_string: ?JSON_STRING
			l_value: ?JSON_VALUE
		do
			create Result.make
			-- check if is an empty object {}
			next
			skip_white_spaces
			if actual = j_OBJECT_CLOSE then
				--is an empty object
			else
				-- a complex object {"key" : "value"}
				previous
				from has_more := True until not has_more loop
					next
					skip_white_spaces
					l_json_string := parse_string
					next
					skip_white_spaces
					if actual = ':' then
						next
						skip_white_spaces
					else
						is_parsed := False
						report_error ("%N Input string is a not well formed JSON, expected: : found: " + actual.out)
						has_more := False
					end

					l_value := parse
					if is_parsed and then (l_value /= Void and l_json_string /= Void) then
						Result.put (l_value, l_json_string)
						next
						skip_white_spaces
						if actual = j_OBJECT_CLOSE then
							has_more := False
						elseif actual /= ',' then
							has_more := False
							is_parsed := False
							report_error ("JSON Object syntactically malformed expected , found: [" + actual.out + "]")
						end
					else
						has_more := False
						-- explain the error
					end
				end
			end
		end

	parse_string: ?JSON_STRING is
			-- Parsed string
		local
			has_more: BOOLEAN
			l_json_string: STRING
			l_unicode: STRING
			c: like actual
		do
			create l_json_string.make_empty
			if actual = j_STRING then
				from
					has_more := True
				until
					not has_more
				loop
					next
					c := actual
					if c = j_STRING then
						has_more := False
					elseif c = '%H' then
						next
						c := actual
						if c = 'u' then
							create l_unicode.make_from_string ("\u")
							l_unicode.append (read_unicode)
							c := actual
							if is_a_valid_unicode (l_unicode) then
								l_json_string.append (l_unicode)
							else
								has_more := False
								is_parsed := False
								report_error ("Input String is not well formed JSON, expected a Unicode value, found [" + c.out + " ]")
							end
						elseif (not is_special_character (c) and not is_special_control (c)) or c = '%N' then
							has_more := False
							is_parsed := False
							report_error ("Input String is not well formed JSON, found [" + c.out + " ]")
						else
							l_json_string.append ("\")
							l_json_string.append (c.out)
						end
					else
						if is_special_character (c) and c /= '/' then
							has_more := False
							is_parsed := False
							report_error ("Input String is not well formed JSON, found [" + c.out + " ]")
						else
							l_json_string.append_character (c)
						end
					end
				end
				create Result.make_json (l_json_string)
			else
				Result := Void
			end
		end

	parse_array: JSON_ARRAY is
			-- array
			-- []
			-- [elements [,]]
		local
			flag: BOOLEAN
			l_value: ?JSON_VALUE
			c: like actual
		do
			create Result.make_array
			--check if is an empty array []
			next
			skip_white_spaces
			if actual = j_array_close then
				--is an empty array
			else
				previous
				from
					flag := True
				until
					not flag
				loop
					next
					skip_white_spaces
					l_value := parse
					if is_parsed and then l_value /= Void then
						Result.add (l_value)
						next
						skip_white_spaces
						c := actual
						if c = j_ARRAY_CLOSE then
							flag := False
 						elseif c /= ',' then
							flag := False
							is_parsed := False
							report_error ("Array is not well formed JSON,  found [" + c.out + " ]")
						end
					else
						flag := False
						report_error ("Array is not well formed JSON,  found [" + actual.out + " ]")
					end
				end
			end
		end

	parse_number: ?JSON_NUMBER is
			-- Parsed number
		local
			sb: STRING
			flag: BOOLEAN
			is_integer: BOOLEAN
			c: like actual
		do
			create sb.make_empty
			sb.append_character (actual)

			from
				flag := True
			until
				not flag
			loop
				next
				c := actual
				if not has_next or is_close_token (c)
					or c = ',' or c = '%N' or c = '%R'
				then
					flag := False
					previous
				else
					sb.append_character (c)
				end
			end

			if is_a_valid_number (sb) then
				if sb.is_integer then
					create Result.make_integer (sb.to_integer)
					is_integer := True
				elseif sb.is_double and not is_integer then
					create Result.make_real (sb.to_double)
				end
			else
				is_parsed := False
				report_error ("Expected a number, found: [ " + sb  + " ]")
			end
		end

	is_null: BOOLEAN is
			-- Word at index represents null?
		local
			l_null: STRING
			l_string: STRING
		do
			l_null := null_id
			l_string := json_substring (index,index + l_null.count - 1)
			if l_string.is_equal (l_null) then
				Result := True
			end
		end

	is_false: BOOLEAN is
			-- Word at index represents false?
		local
			l_false: STRING
			l_string: STRING
		do
			l_false := false_id
			l_string := json_substring (index, index + l_false.count - 1)
			if l_string.is_equal (l_false) then
				Result := True
			end
		end

	is_true: BOOLEAN is
			-- Word at index represents true?
		local
			l_true: STRING
			l_string: STRING
		do
			l_true := true_id
			l_string := json_substring (index,index + l_true.count - 1)
			if l_string.is_equal (l_true) then
				Result := True
			end
		end

	read_unicode: STRING is
			-- Read unicode and return value
		local
			i: INTEGER
		do
			create Result.make_empty
			from
				i := 1
			until
				i > 4 or not has_next
			loop
				next
				Result.append_character (actual)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	is_a_valid_number (a_number: STRING): BOOLEAN is
			-- is 'a_number' a valid number based on this regular expression
			-- "-?(?: 0|[1-9]\d+)(?: \.\d+)?(?: [eE][+-]?\d+)?\b"?
		local
			word_set: RX_CHARACTER_SET
			regexp: RX_PCRE_REGULAR_EXPRESSION
			number_regex: STRING
		do
			create regexp.make
			create word_set.make_empty
			a_number.right_adjust
			a_number.left_adjust
			word_set.add_string ("0123456789.eE+-")
			regexp.set_word_set (word_set)
			number_regex := "-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?\b"
			regexp.compile (number_regex)
			if regexp.matches (a_number) then
				Result := a_number.is_equal (regexp.captured_substring (0))
			end
		end

	is_a_valid_unicode (a_unicode: STRING): BOOLEAN is
			-- is 'a_unicode' a valid unicode based on this regular expression
			-- "\\u[0-9a-fA-F]{4}"
		local
			regexp: RX_PCRE_REGULAR_EXPRESSION
			unicode_regex: STRING
		do
			create regexp.make
			unicode_regex := "\\u[0-9a-fA-F]{4}"
			regexp.compile (unicode_regex)
			if regexp.matches (a_unicode) then
				Result := True
				check
					is_valid: a_unicode.is_equal (regexp.captured_substring (0))
				end
			end
		end

	extra_elements: BOOLEAN is
			-- has more elements?
		local
			c: like actual
		do
			if has_next then
				next
			end
			from
				c := actual
			until
				c /= ' ' or c /= '%R' or c /= '%U' or c /= '%T' or c /= '%N' or not has_next
			loop
				next
			end
			Result := has_next
		end

feature {NONE} -- Constants

	false_id: STRING is "false"

	true_id: STRING is "true"

	null_id: STRING is "null"


end
