note
	description: "Summary description for {URI_TEMPLATE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	URI_TEMPLATE_EXPRESSION

inherit
	DEBUG_OUTPUT

create
	make

feature {NONE} -- Initialization

	make (a_position: INTEGER; a_expression: STRING; a_is_query: BOOLEAN)
		do
			position := a_position
			expression := a_expression
			is_query := a_is_query
			operator := '%U'
		end

feature -- Processing

	analyze
		local
			exp: like expression
			s: detachable STRING
			lst: LIST [STRING]
			p: INTEGER
			vars: like variables
			vn: STRING
			vmodifier: detachable STRING
			i,n: INTEGER
		do
			if not is_analyzed then
				exp := expression
				if not exp.is_empty then
					op_prefix := '%U'
					op_delimiter := ','
					inspect exp[1]
					when '+' then
						reserved := True
						operator := '+'
					when '.' then
						operator := '.'
						op_prefix := '.'
						op_delimiter := '.'
					when '/' then
						operator := '/'
						op_prefix := '/'
						op_delimiter := '/'
					when ';' then
						operator := ';'
						op_prefix := ';'
						op_delimiter := ';'
					when '?' then
						operator := '?'
						op_prefix := '?'
						op_delimiter := '&'
					when '|', '!', '@' then
						operator := exp[1]
					else
						operator := '%U'
					end
					if operator /= '%U' then
						s := exp.substring (2, exp.count)
					else
						s := exp
					end

					lst := s.split (',')
					from
						create {ARRAYED_LIST [like variables.item]} vars.make (lst.count)
						lst.start
					until
						lst.after
					loop
						s := lst.item
						vmodifier := Void
						p := s.index_of ('|', 1)
						if p > 0 then
							vn := s.substring (1, p - 1)
							s := s.substring (p + 1, s.count)
						else
							vn := s
							s := Void
						end
						from
							vmodifier := Void
							i := 1
							n := vn.count
						until
							i > n
						loop
							inspect vn[i]
							when '*', '+', ':', '^' then
								vmodifier := vn.substring (i, n)
								vn := vn.substring (1, i - 1)
								i := n + 1 --| exit
							else
								i := i + 1
							end
						end
						vars.force (create {URI_TEMPLATE_EXPRESSION_VARIABLE}.make (operator, vn, s, vmodifier))
						lst.forth
					end
					variables := vars
				end
				is_analyzed := True
			end
		end

feature -- Access

	position: INTEGER

	expression: STRING

	is_query: BOOLEAN

feature -- Status

	operator: CHARACTER

	has_operator: BOOLEAN
		do
			Result := operator /= '%U'
		end

	reserved: BOOLEAN

	has_op_prefix: BOOLEAN
		do
			Result := op_prefix /= '%U'
		end

	op_prefix: CHARACTER

	op_delimiter: CHARACTER

	variables: detachable LIST [URI_TEMPLATE_EXPRESSION_VARIABLE]

	variable_names: LIST [STRING]
		do
			analyze
			if attached variables as vars then
				create {ARRAYED_LIST [STRING]} Result.make (vars.count)
				from
					vars.start
				until
					vars.after
				loop
					Result.force (vars.item.name)
					vars.forth
				end
			else
				create {ARRAYED_LIST [STRING]} Result.make (0)
			end
		end

feature -- Status report

	is_analyzed: BOOLEAN

feature -- Report

	append_to_string (a_ht: HASH_TABLE [detachable ANY, STRING]; a_buffer: STRING)
		do
			analyze
			if attached variables as vars then
				append_custom_variables_to_string (a_ht, vars, op_prefix, op_delimiter, True, a_buffer)
--				inspect operator
--				when '?' then
--					append_custom_variables_to_string (a_ht, vars, '?', '&', True, a_buffer)
--				when ';' then
--					append_custom_variables_to_string (a_ht, vars, ';', ';', False, a_buffer)
--				when '.' then
--					append_custom_variables_to_string (a_ht, vars, '.', ',', True, a_buffer)
--				when '/' then
--					append_custom_variables_to_string (a_ht, vars, '/', '/', True, a_buffer)
--				else
--					append_custom_variables_to_string (a_ht, vars, '%U', ',', False, a_buffer)
--				end
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

	append_custom_variables_to_string (a_ht: HASH_TABLE [detachable ANY, STRING]; vars: like variables; prefix_char, delimiter_char: CHARACTER; a_include_name: BOOLEAN; a_buffer: STRING)
			-- If `first_char' is '%U' do not print any first character
		local
			vi: like variables.item
			l_is_first: BOOLEAN
			vdata: detachable ANY
			vstr: detachable STRING
			l_use_default: BOOLEAN
		do
			if vars /= Void then
				from
					vars.start
					l_is_first := True
				until
					vars.after
				loop
					vi := vars.item
					vdata := a_ht.item (vi.name)
					vstr := Void
					if vdata /= Void then
						vstr := vi.string (vdata)
						if vstr = Void and vi.has_explode_modifier then
							--| Missing or list empty
							vstr := vi.default_value
							l_use_default := True
						else
							l_use_default := False
						end
					else
						--| Missing
						vstr := vi.default_value
						l_use_default := True
					end
					if vstr /= Void then
						if l_is_first then
							if prefix_char /= '%U' then
								a_buffer.append_character (prefix_char)
							end
							l_is_first := False
						else
							a_buffer.append_character (delimiter_char)
						end
						if l_use_default and (operator = '?') and not vi.has_explode_modifier_star then
							a_buffer.append (vi.name)
							if vi.has_explode_modifier_plus then
								a_buffer.append_character ('.')
							else
								a_buffer.append_character ('=')
							end
						end
						a_buffer.append (vstr)
					end
					vars.forth
				end
			end
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := expression
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
