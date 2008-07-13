indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_PARSER
		inherit
		JSON_READER
		JSON_TOKENS

create
	make_parser
feature -- Access
    is_parsed:BOOLEAN

    current_errors:STRING

	make_parser(a_json:STRING) is
			--
			do
				make(a_json)
				is_parsed:=true
				create current_errors.make_empty
			end

    parse_json:JSON_VALUE is
    		--
    	do
    		Result:=parse
    		if extra_elements then
    			is_parsed:=false
    		end
    	end

	parse:JSON_VALUE is
			--
			local
				c:CHARACTER
			do
				if is_parsed then
					skip_withe_spaces
					c:=actual
					if c.is_equal (j_object_open) then
						Result:=parse_object
					elseif c.is_equal (j_string) then
						Result:=parse_string
					elseif c.is_equal (j_array_open) then
						Result:=parse_array
					elseif c.is_digit or c.is_equal (j_minus)  then
						Result:=parse_number
					elseif is_null  then
						--
						Result:=create {JSON_NULL}
						next;next;next;
					elseif is_true then
						Result:=create {JSON_BOOLEAN}.make_boolean (true)
						next;next;next;
					elseif is_false then
						Result:=create {JSON_BOOLEAN}.make_boolean (false)
						next;next;next;next;
					else
						is_parsed:=false
						current_errors.append("JSON is not well formed in parse")
						Result:=void
					end
				end
		  end

	parse_object:JSON_OBJECT is
			-- object
			-- {}
			-- {"key" : "value" [,]}

			local
				has_more:BOOLEAN
				l_json_string:JSON_STRING
				l_value:JSON_VALUE
			do
				create Result.make
				-- check if is an empty object {}
				next
				skip_withe_spaces
				if actual.is_equal (j_object_close) then
				   --is an empty object		
				else
				    -- a complex object {"key" : "value"}
					previous
					from has_more:=true until not has_more
					loop
						next
						skip_withe_spaces
						l_json_string:=parse_string
						next
						skip_withe_spaces
 						if actual.is_equal (':') then
						  	next
						  	skip_withe_spaces
						else
						  is_parsed:=false
						  current_errors.append("%N Input string is a not well formed JSON, expected: : found:" + actual.out +"%N")
						  has_more:=false
						end

						l_value:=parse
						if is_parsed then
							Result.put (l_value,l_json_string)
							next
							skip_withe_spaces
							if actual.is_equal (j_object_close) then
								has_more:=false
							elseif not actual.is_equal (',') then
								has_more:=false
								is_parsed:=false
				  			    current_errors.append("JSON Object sintactically malformed expected , found:[" + actual.out + "] %N")
							end
					    else
					    	has_more:=false
					    	-- explain the error	
					    end
					end
				end
			end

	parse_string:JSON_STRING is
			--
			local
				has_more:BOOLEAN
				l_json_string:STRING
				l_unicode:STRING
			do
				create l_json_string.make_empty
				if actual.is_equal (j_string) then
					from
						has_more:=true
					until not has_more

					loop
						next
						if actual.is_equal (j_string) then
							has_more:=false
						elseif actual.is_equal ('%H') then
							next
							if actual.is_equal ('u') then
								create l_unicode.make_from_string ("\u")
								l_unicode.append (read_unicode)
								if is_a_valid_unicode(l_unicode) then
									l_json_string.append (l_unicode)
								else
									has_more:=false
									is_parsed:=false
									current_errors.append("Input String is not well formed JSON, expected a Unicode value, found [" + actual.out + " ] %N")
								end
							elseif (not special_characters.has (actual) and  not special_controls.has (actual)) or actual.is_equal ('%N') then
								has_more:=false
								is_parsed:=false
								current_errors.append("Input String is not well formed JSON, found [" + actual.out + " ] %N")

							else
								l_json_string.append ("\")
								l_json_string.append (actual.out)

							end

						else
							if special_characters.has (actual) and not actual.is_equal ('/') then
								has_more:=false
								is_parsed:=false
								current_errors.append("Input String is not well formed JSON, found [" + actual.out + " ] %N")
							else
								l_json_string.append (actual.out)
							end
						end
					end
					create Result.make_json (l_json_string)
				else
					Result := void
		        end
			end

		parse_array:JSON_ARRAY is
			-- array
			-- []
			-- [elements [,]]
			local
				flag:BOOLEAN
				l_value:JSON_VALUE
			do
				create Result.make_array
				--check if is an empty array []
				next
				skip_withe_spaces
				if actual.is_equal (j_array_close) then
				   --is an empty array		
				else
					previous
					from
						flag:=true
					until
						not flag
					loop
						next
						skip_withe_spaces
						l_value := parse
						if is_parsed then
							Result.add (l_value)
							next
							skip_withe_spaces
							if  not actual.is_equal (j_array_close) and not actual.is_equal (',')then
								flag:=false
								is_parsed:=false
								current_errors.append("Array is not well formed JSON,  found [" + actual.out + " ] %N")
							elseif actual.is_equal (j_array_close)	then
							    flag:= false
							end
						else
							flag:=false
								current_errors.append("Array is not well formed JSON,  found [" + actual.out + " ] %N")
						end
					end
				end
			end

	parse_number:JSON_NUMBER is
			--
			local
				sb:STRING
				flag:BOOLEAN
			    is_integer:BOOLEAN
			do
				create sb.make_empty
				sb.append (actual.out)

			 	from
					flag:=true
				until not flag
				loop
					next
					if not has_next or close_tokens.has (actual) or actual.is_equal (',')
					  or actual.is_equal ('%N')  or actual.is_equal ('%R') then
					    flag:=false
						previous
					else
						sb.append (actual.out)
					end
				end

			    if is_a_valid_number(sb) then
					if sb.is_integer then
						create Result.make_integer (sb.to_integer)
						is_integer:=true;
					elseif sb.is_double and not is_integer then
						create Result.make_real (sb.to_double)
					end
		    	else
				    is_parsed:=false
				    current_errors.append("Expected a number, found: [ " + sb  + " ]")
				end
			end



		is_null:BOOLEAN is
			--
			local
				l_null:STRING
				l_string:STRING
			do
				l_null:="null"
				l_string:=json_substring (index,index + l_null.count - 1)
				if l_string.is_equal (l_null) then
					Result := true
				end
			end

		is_false:BOOLEAN is
			--
			local
			l_false:STRING
			l_string:STRING
			do
				l_false:="false"
				l_string:=json_substring (index,index + l_false.count - 1)
				if l_string.is_equal (l_false) then
					Result := true
				end
			end

		is_true:BOOLEAN is
				--
				local
					l_true:STRING
					l_string:STRING
				do
					l_true:="true"
					l_string:=json_substring (index,index + l_true.count - 1)
					if l_string.is_equal (l_true) then
						Result := true
					end
				end

		read_unicode:STRING is
				--
			local
			i:INTEGER
			do
				create Result.make_empty
				from
					i:=1
				until i > 4 or not has_next

				loop
				    next
				    Result.append(actual.out)
				    i:= i + 1
				end
			end

feature {NONE}

         is_a_valid_number(a_number:STRING):BOOLEAN is
    		-- is 'a_number' a valid number based on this regular expression
    		-- "-?(?:0|[1-9]\d+)(?:\.\d+)?(?:[eE][+-]?\d+)?\b"?
    		local
    		case_mapping: RX_CASE_MAPPING
			word_set: RX_CHARACTER_SET
			regexp: RX_PCRE_REGULAR_EXPRESSION
    		number_regex:STRING
    		l_number:STRING
    		do
		      create regexp.make
		      create word_set.make_empty
		      word_set.add_string ("0123456789.eE+-")
		      regexp.set_word_set (word_set)
		      number_regex:="-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?\b"
		      regexp.compile(number_regex)
              if regexp.matches (a_number) then
              	   a_number.right_adjust
	               if  a_number.is_equal(regexp.captured_substring (0)) then
    	                   Result := true
                   end
              end
            end

	  is_a_valid_unicode(a_unicode:STRING):BOOLEAN is
    		-- is 'a_unicode' a valid unicode based on this regular expression
    		-- "\\u[0-9a-fA-F]{4}"
    		local
    		case_mapping: RX_CASE_MAPPING
			word_set: RX_CHARACTER_SET
			regexp: RX_PCRE_REGULAR_EXPRESSION
    		unicode_regex:STRING
    		do
		      create regexp.make
		      unicode_regex:="\\u[0-9a-fA-F]{4}"
		      regexp.compile(unicode_regex)
              if regexp.matches (a_unicode) then
                   Result := true
                   check
                   	   is_valid: a_unicode.is_equal(regexp.captured_substring (0))
                   end
              end
            end



		extra_elements:BOOLEAN is
				--has more elements?
				local
					l_string:STRING
				do

                    if has_next then
                    	next
                    end
					from
					until not actual.is_space or  not actual.is_equal ('%R') or
						  not actual.is_equal ('%U') or  not actual.is_equal ('%T')
						  or not actual.is_equal ('%N') or not has_next
					loop
						next
					end

                    if has_next then
                    	Result:=True
                    end

				end


end
