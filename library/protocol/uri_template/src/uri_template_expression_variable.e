note
	description: "Summary description for {URI_TEMPLATE_EXPRESSION_VARIABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	URI_TEMPLATE_EXPRESSION_VARIABLE

create
	make

feature {NONE} -- Initialization

	make (op: like operator; n: like name; d: like default_value; m: like modifier)
		do
			operator := op
			name := n
			default_value := d
			modifier := m


			op_prefix := '%U'
			op_separator := ','

			inspect op
			when '+' then
				reserved := True
			when '?' then
				op_prefix := '?'
				op_separator := '&'
			when ';' then
				op_prefix := ';'
				op_separator := ';'
			when '/' then
				op_prefix := '/'
				op_separator := '/'
			when '.' then
				op_prefix := '.'
				op_separator := '.'
			else

			end
		end

feature -- Access

	operator: CHARACTER

	name: STRING

	default_value: detachable STRING

	reserved: BOOLEAN

	op_prefix: CHARACTER

	op_separator: CHARACTER

	modifier: detachable STRING

	has_modifier: BOOLEAN
		do
			Result := modifier /= Void
		end

	modified (s: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		local
			t: STRING
			i,n: INTEGER
		do
			Result := s
			if attached modifier as m and then m.count > 1 and then m[1] = ':' then
				n := s.count
				t := m.substring (2, m.count)
				if t.is_integer then
					i := t.to_integer
					if i > 0 then
						if i < n then
							Result := s.substring (1, i)
						end
					elseif i < 0 then
						Result := s.substring (n - i, n)
					end
				end
			end
		end

	has_explode_modifier: BOOLEAN
		do
			Result := attached modifier as m and then m.count = 1 and then (
						m[1] = '+' or m[1] = '*'
						)
		end

	has_explode_modifier_plus: BOOLEAN
		do
			Result := attached modifier as m and then m.count = 1 and then
						m[1] = '+'
		end

	has_explode_modifier_star: BOOLEAN
		do
			Result := attached modifier as m and then m.count = 1 and then
						m[1] = '*'
		end

feature -- Report

	string (d: detachable ANY): detachable STRING
		local
			l_delimiter: CHARACTER
			v_enc: detachable STRING
			k_enc: STRING
			l_obj: detachable ANY
			i,n: INTEGER
			modifier_is_plus: BOOLEAN
			modifier_is_star: BOOLEAN
			modifier_has_explode: BOOLEAN
			dft: detachable ANY
			has_list_op: BOOLEAN
		do
			modifier_has_explode := has_explode_modifier
			if modifier_has_explode then
				modifier_is_plus := has_explode_modifier_plus
				modifier_is_star := has_explode_modifier_star
			end
			has_list_op := operator /= '%U' and operator /= '+'
			dft := default_value
			create Result.make (20)
			if attached {READABLE_STRING_GENERAL} d as l_string then
				v_enc := url_encoded_string (modified (l_string), not reserved)
				if operator = '?' then
	                Result.append (name)
	                Result.append_character ('=')
				elseif operator = ';' then
	                Result.append (name)
	                if not v_enc.is_empty then
		                Result.append_character ('=')
	                end
				end
				Result.append (v_enc)
			elseif attached {ARRAY [detachable ANY]} d as l_array then
				if l_array.is_empty then
					if dft /= Void then
						inspect operator
						when '?',';' then
							if not modifier_has_explode then
								Result.append (name)
								Result.append_character ('=')
								Result.append (dft.out)
							else
								if modifier_is_plus then
									Result.append (name)
									Result.append_character ('.')
								end
								Result.append (dft.out)
							end
						when '/' then
							if modifier_is_plus then
								Result.append (name)
								Result.append_character ('.')
							end
							Result.append (dft.out)
						when '.' then
						else
							if modifier_has_explode then
								if modifier_is_plus then
									Result.append (name)
									Result.append_character ('.')
								end
								Result.append (dft.out)
							end
						end
					else
						-- nothing ...
					end
				else
					if modifier_has_explode then
						l_delimiter := op_separator
					else
						l_delimiter := ','
						inspect operator
						when '?' then
							Result.append (name)
							Result.append_character ('=')
						when ';' then
						when '/' then
--							Result.append_character ('/')
						else
						end
					end

					from
						i := l_array.lower
						n := l_array.upper
					until
						i > n
					loop
						l_obj := l_array[i]
						if l_obj /= Void then
							v_enc := url_encoded_string (l_obj.out, not reserved)
						else
							v_enc := ""
						end
						if modifier_is_plus then
							if
								(operator = '?' and modifier_is_plus) or
								(operator = ';' and modifier_has_explode)
							then
								Result.append (name)
								Result.append_character ('=')
							else
								Result.append (name)
								Result.append_character ('.')
							end
						elseif modifier_is_star and operator = '?' then
							Result.append (name)
							Result.append_character ('=')
						end
						Result.append (v_enc)
						if i < n then
							Result.append_character (l_delimiter)
						end

						i := i + 1
					end
				end
				if Result.is_empty then
					Result := Void
				end
			elseif attached {HASH_TABLE [detachable ANY, STRING]} d as l_table then
--				if operator = '?' and not modifier_has_explode and l_table.is_empty and dft = Void then
--				elseif operator = '?' and not modifier_has_explode then
--					Result.append (name)
--					Result.append_character ('=')
--					if l_table.is_empty and dft /= Void then
--						Result.append (dft.out)
--					end
--				elseif l_table.is_empty and dft /= Void then
--					if modifier_has_explode then
--						if modifier_is_plus then
--							Result.append (name)
--							Result.append_character ('.')
--						end
--						Result.append (dft.out)
--					end
--				end
				if l_table.is_empty then
					if dft /= Void then
						inspect operator
						when '?',';' then
							if not modifier_has_explode then
								Result.append (name)
								Result.append_character ('=')
								Result.append (dft.out)
							else
								if modifier_is_plus then
									Result.append (name)
									Result.append_character ('.')
								end
								Result.append (dft.out)
							end
						when '/' then
							if modifier_is_plus then
								Result.append (name)
								Result.append_character ('.')
							end
							Result.append (dft.out)
						when '.' then
						else
							if modifier_has_explode then
								if modifier_is_plus then
									Result.append (name)
									Result.append_character ('.')
								end
								Result.append (dft.out)
							end
						end
					else
						-- nothing ...
					end
				else
					if modifier_has_explode then
						l_delimiter := op_separator
					else
						l_delimiter := ','
						inspect operator
						when '?' then
							Result.append (name)
							Result.append_character ('=')
						when ';' then
						when '/' then
						else
						end
					end

					from
						l_table.start
					until
						l_table.after
					loop
						k_enc := url_encoded_string (l_table.key_for_iteration, not reserved)
						l_obj := l_table.item_for_iteration
						if l_obj /= Void then
							v_enc := url_encoded_string (l_obj.out, not reserved)
						else
							v_enc := ""
						end

						if modifier_is_plus then
							Result.append (name)
							Result.append_character ('.')
						end
						if
							modifier_has_explode and
							(
								operator = '%U' or
								operator = '+' or
								operator = '?' or
								operator = '.' or
								operator = ';' or
								operator = '/'
							)
						then
							Result.append (k_enc)
							Result.append_character ('=')
						else
							Result.append (k_enc)
							Result.append_character (l_delimiter)
						end
						Result.append (v_enc)

						l_table.forth
						if not l_table.after then
							Result.append_character (l_delimiter)
						end
					end
				end
				if Result.is_empty then
					Result := Void
				end
			else
				if d /= Void then
					v_enc := url_encoded_string (d.out, not reserved)
				elseif dft /= Void then
					v_enc := url_encoded_string (dft.out, not reserved)
				else
					v_enc := default_value
				end
				if operator = '?' then
	                Result.append (name)
	                if v_enc /= Void then
		                Result.append_character ('=')
	                end
	            elseif operator = ';' then
	                Result.append (name)
	                if v_enc /= Void and then not v_enc.is_empty then
		                Result.append_character ('=')
	                end
				end
				if v_enc /= Void then
					Result.append (v_enc)
				end
			end
		end

feature {NONE} -- Implementation

	url_encoded_string (s: READABLE_STRING_GENERAL; a_encoded: BOOLEAN): STRING
		do
			if a_encoded then
				Result := url_encoder.encoded_string (s.as_string_32)
			else
				Result := url_encoder.partial_encoded_string (s.as_string_32, <<
									':', ',',
									'+', '.', '/', ';', '?',
									'|', '!', '@'
									>>)
			end
		end

	url_encoder: URL_ENCODER
		once
			create Result
		end

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
