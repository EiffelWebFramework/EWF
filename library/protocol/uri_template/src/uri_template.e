note
	description: "[
			Summary description for {URI_TEMPLATE}.
			
			See http://tools.ietf.org/html/draft-gregorio-uritemplate-04
			
			note for draft 05, check {URI_TEMPLATE_CONSTANTS}.Default_delimiter

			]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	URI_TEMPLATE

inherit
	HASHABLE

	DEBUG_OUTPUT

create
	make

feature {NONE} -- Initialization

	make (s: STRING)
		do
			template := s
		end

feature -- Access

	template: STRING
			-- URI string representation

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make_from_string (template)
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := template.hash_code
		end

feature -- Structures

	variable_names: LIST [STRING]
			-- All variable names
		do
			analyze
			if attached expressions as l_expressions then
				create {ARRAYED_LIST [STRING]} Result.make (l_expressions.count)
				from
					l_expressions.start
				until
					l_expressions.after
				loop
					Result.append (l_expressions.item.variable_names)
					l_expressions.forth
				end
			else
				create {ARRAYED_LIST [STRING]} Result.make (0)
			end
		end

	path_variable_names: LIST [STRING]
			-- All variable names part of the path
		do
			analyze
			if attached expressions as l_expressions then
				create {ARRAYED_LIST [STRING]} Result.make (l_expressions.count)
				from
					l_expressions.start
				until
					l_expressions.after
				loop
					if not l_expressions.item.is_query then
						Result.append (l_expressions.item.variable_names)
					end
					l_expressions.forth
				end
			else
				create {ARRAYED_LIST [STRING]} Result.make (0)
			end
		end

	query_variable_names: LIST [STRING]
			-- All variable names part of the query (i.e after '?')	
		do
			analyze
			if attached expressions as l_expressions then
				create {ARRAYED_LIST [STRING]} Result.make (l_expressions.count)
				from
					l_expressions.start
				until
					l_expressions.after
				loop
					if l_expressions.item.is_query then
						Result.append (l_expressions.item.variable_names)
					end
					l_expressions.forth
				end
			else
				create {ARRAYED_LIST [STRING]} Result.make (0)
			end
		end

feature -- Builder

	expanded_string (a_ht: HASH_TABLE [detachable ANY, STRING]): STRING
			-- Expanded template using variable from `a_ht'
		local
			tpl: like template
			exp: URI_TEMPLATE_EXPRESSION
			p,q: INTEGER
		do
			analyze
			tpl := template
			if attached expressions as l_expressions then
				create Result.make (tpl.count)
				from
					l_expressions.start
					p := 1
				until
					l_expressions.after
				loop
					q := l_expressions.item.position
						--| Added inter variable text
					Result.append (tpl.substring (p, q - 1))
						--| Expand variables ...
					exp := l_expressions.item
					exp.append_expanded_to_string (a_ht, Result)

					p := q + l_expressions.item.expression.count + 2

					l_expressions.forth
				end
				Result.append (tpl.substring (p, tpl.count))
			else
				create Result.make_from_string (tpl)
			end
		end

feature -- Match

	match (a_uri: STRING): detachable URI_TEMPLATE_MATCH_RESULT
		local
			b: BOOLEAN
			tpl: like template
			l_offset: INTEGER
			p,q: INTEGER
			exp: URI_TEMPLATE_EXPRESSION
			vn, s,t: STRING
			vv: STRING
			l_vars, l_path_vars, l_query_vars: HASH_TABLE [STRING, STRING]
			l_uri_count: INTEGER
		do
				--| Extract expansion parts  "\\{([^\\}]*)\\}"
			analyze
			if attached expressions as l_expressions then
				create l_path_vars.make (l_expressions.count)
				create l_query_vars.make (l_expressions.count)
				l_vars := l_path_vars
				b := True
				l_uri_count := a_uri.count
				tpl := template
				if l_expressions.is_empty then
					b := a_uri.substring (1, tpl.count).same_string (tpl)
				else
					from
						l_expressions.start
						p := 0
						l_offset := 0
					until
						l_expressions.after or not b
					loop
						exp := l_expressions.item
						vn := exp.expression
						q := exp.position
							--| Check text between vars
						if p = q then
							--| There should be at least one literal between two expression
							--|  {var}{foobar}  is ambigous for matching ...
							b := False
						elseif q > p then
							if p = 0 then
								p := 1
							end
							t := tpl.substring (p, q - 1)
							s := a_uri.substring (p + l_offset, q + l_offset - 1)
							b := s.same_string (t)
							p := exp.end_position
						end
							--| Check related variable
						if b and then not vn.is_empty then
							if exp.is_query then
								l_vars := l_query_vars
							else
								l_vars := l_path_vars
							end
							if q + l_offset <= l_uri_count then
								inspect vn[1]
								when '?' then
									import_form_style_parameters_into (a_uri.substring (q + l_offset + 1, l_uri_count), l_vars)
								when ';' then
									import_path_style_parameters_into (a_uri.substring (q + l_offset, l_uri_count), l_vars)
								else
									vv := next_path_variable_value (a_uri, q + l_offset)
									l_vars.force (vv, vn)
									l_offset := l_offset + vv.count - (vn.count + 2)
								end
							else
								b := exp.is_query --| query are optional
							end
						end
						l_expressions.forth
					end
				end
				if b then
					create Result.make (l_path_vars, l_query_vars)
				end
			end
		end

feature {NONE} -- Internal Access

	expressions: detachable LIST [URI_TEMPLATE_EXPRESSION]
			-- Expansion parts

feature {NONE} -- Implementation

	analyze
		local
			l_expressions: like expressions
			c: CHARACTER
			i,p,n: INTEGER
			tpl: like template
			in_x: BOOLEAN
			in_query: BOOLEAN
			x: STRING
			exp: URI_TEMPLATE_EXPRESSION
		do
			l_expressions := expressions
			if l_expressions = Void then
				tpl := template

					--| Extract expansion parts  "\\{([^\\}]*)\\}"
				create {ARRAYED_LIST [like expressions.item]} l_expressions.make (tpl.occurrences ('{'))
				from
					i := 1
					n := tpl.count
					create x.make_empty
				until
					i > n
				loop
					c := tpl[i]
					if in_x then
						if c = '}' then
							create exp.make (p, x.twin, in_query)
							l_expressions.force (exp)
							x.wipe_out
							in_x := False
						else
							x.extend (c)
						end
					else
						inspect c
						when '{' then
							check x_is_empty: x.is_empty end
							p := i
							in_x := True
							if not in_query then
								in_query := tpl.valid_index (i+1) and then tpl[i+1] = '?'
							end
						when '?' then
							in_query := True
						else
						end
					end
					i := i + 1
				end
				expressions := l_expressions
			end
		end

	import_path_style_parameters_into (a_content: STRING; res: HASH_TABLE [STRING, STRING])
		require
			a_content_attached: a_content /= Void
			res_attached: res /= Void
		do
			import_custom_style_parameters_into (a_content, ';', res)
		end

	import_form_style_parameters_into (a_content: STRING; res: HASH_TABLE [STRING, STRING])
		require
			a_content_attached: a_content /= Void
			res_attached: res /= Void
		do
			import_custom_style_parameters_into (a_content, '&', res)
		end

	import_custom_style_parameters_into (a_content: STRING; a_separator: CHARACTER; res: HASH_TABLE [STRING, STRING])
		require
			a_content_attached: a_content /= Void
			res_attached: res /= Void
		local
			n, p, i, j: INTEGER
			s: STRING
			l_name,l_value: STRING
		do
			n := a_content.count
			if n > 0 then
				from
					p := 1
				until
					p = 0
				loop
					i := a_content.index_of (a_separator, p)
					if i = 0 then
						s := a_content.substring (p, n)
						p := 0
					else
						s := a_content.substring (p, i - 1)
						p := i + 1
					end
					if not s.is_empty then
						j := s.index_of ('=', 1)
						if j > 0 then
							l_name := s.substring (1, j - 1)
							l_value := s.substring (j + 1, s.count)
							res.force (l_value, l_name)
						end
					end
				end
			end
		end

	next_path_variable_value (a_uri: STRING; a_index: INTEGER): STRING
		require
			valid_index: a_index <= a_uri.count
		local
			i,n,p: INTEGER
		do
			from
				i := a_index
				n := a_uri.count
			until
				i > n
			loop
				inspect a_uri[i]
				when '/', '?' then
					i := n
				else
					p := i
				end
				i := i + 1
			end
			Result := a_uri.substring (a_index, p)
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
