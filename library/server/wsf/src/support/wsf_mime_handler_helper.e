note
	description: "Summary description for {WSF_MIME_HANDLER_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_MIME_HANDLER_HELPER

feature {NONE} -- Implementation

	read_input_data (a_input: WGI_INPUT_STREAM; nb: NATURAL_64): READABLE_STRING_8
			-- All data from input form
		local
			nb32: INTEGER
			n64: NATURAL_64
			n: INTEGER
			t: STRING
			s: STRING_8
		do
			from
				n64 := nb
				nb32 := n64.to_integer_32
				create s.make (nb32)
				Result := s
				n := nb32
				if n > 1_024 then
					n := 1_024
				end
			until
				n64 <= 0
			loop
				a_input.read_string (n)
				t := a_input.last_string
				s.append_string (t)
				if t.count < n then
					n64 := 0
				else
					n64 := n64 - t.count.as_natural_64
				end
			end
		end

	add_value_to_table (a_name: READABLE_STRING_8; a_value: READABLE_STRING_8; a_table: HASH_TABLE [WSF_VALUE, READABLE_STRING_32])
		local
			l_decoded_name: STRING_32
			v: detachable WSF_VALUE
			n,k,r: STRING_32
--			k32: STRING_32
			p,q: INTEGER
			tb,ptb: detachable WSF_TABLE
		do
			--| Check if this is a list format such as   choice[]  or choice[a] or even choice[a][] or choice[a][b][c]...
			l_decoded_name := url_encoder.decoded_string (a_name)
			p := l_decoded_name.index_of ({CHARACTER_32}'[', 1)
			if p > 0 then
				q := l_decoded_name.index_of ({CHARACTER_32}']', p + 1)
				if q > p then
					n := l_decoded_name.substring (1, p - 1)
					r := l_decoded_name.substring (q + 1, l_decoded_name.count)
					r.left_adjust; r.right_adjust

					create tb.make (n)
					if a_table.has_key (tb.name) and then attached {WSF_TABLE} a_table.found_item as l_existing_table then
						tb := l_existing_table
					end

					k := l_decoded_name.substring (p + 1, q - 1)
					k.left_adjust; k.right_adjust
					if k.is_empty then
						k.append_integer (tb.count + 1)
					end
					v := tb
					n.append_character ({CHARACTER_32}'[')
					n.append (k)
					n.append_character ({CHARACTER_32}']')

					from
					until
						r.is_empty
					loop
						ptb := tb
						p := r.index_of ({CHARACTER_32} '[', 1)
						if p > 0 then
							q := r.index_of ({CHARACTER_32} ']', p + 1)
							if q > p then
--								k32 := url_encoder.decoded_string (k)
								if attached {WSF_TABLE} ptb.value (k) as l_tb_value then
									tb := l_tb_value
								else
									create tb.make (n)
									ptb.add_value (tb, k)
								end

								k := r.substring (p + 1, q - 1)
								r := r.substring (q + 1, r.count)
								r.left_adjust; r.right_adjust
								if k.is_empty then
									k.append_integer (tb.count + 1)
								end
								n.append_character ('[')
								n.append (k)
								n.append_character (']')
							end
						else
							r.wipe_out
							--| Ignore bad value
						end
					end
					tb.add_value (new_string_value (n, a_value), k)
				else
					--| Missing end bracket
				end
			end
			if v = Void then
				v := new_string_value (a_name, a_value)
			end
			if a_table.has_key (v.name) and then attached a_table.found_item as l_existing_value then
				if tb /= Void then
					--| Already done in previous part
				elseif attached {WSF_MULTIPLE_STRING} l_existing_value as l_multi then
					l_multi.add_value (v)
				else
					a_table.force (create {WSF_MULTIPLE_STRING}.make_with_array (<<l_existing_value, v>>), v.name)
					check replaced: a_table.found and then a_table.found_item ~ l_existing_value end
				end
			else
				a_table.force (v, v.name)
			end
		end

	new_string_value (a_name: READABLE_STRING_8; a_value: READABLE_STRING_8): WSF_STRING
		do
			create Result.make (a_name, a_value)
		end

feature {NONE} -- Implementation

	url_encoder: URL_ENCODER
		once
			create {UTF8_URL_ENCODER} Result
		end

end
