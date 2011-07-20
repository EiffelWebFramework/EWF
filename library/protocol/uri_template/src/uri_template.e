note
	description: "[
			Summary description for {URI_TEMPLATE}.
			
			See http://tools.ietf.org/html/draft-gregorio-uritemplate-05
			
			]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	URI_TEMPLATE

create
	make

feature {NONE} -- Initialization

	make (s: STRING)
		do
			template := s
		end

	make_with_handler (s: STRING; a_handler: detachable URI_TEMPLATE_HANDLER)
		do
			make (s)
			analyze (a_handler)
		end

feature -- Access

	template: STRING
			-- URI string representation

	path_variable_names: LIST [STRING]
		do
			analyze (Void)
			if attached expansion_parts as l_x_parts then
				create {ARRAYED_LIST [STRING]} Result.make (l_x_parts.count)
				from
					l_x_parts.start
				until
					l_x_parts.after
				loop
					if not l_x_parts.item.is_query then
						Result.append (l_x_parts.item.variable_names)
					end
					l_x_parts.forth
				end
			else
				create {ARRAYED_LIST [STRING]} Result.make (0)
			end
		end

	query_variable_names: LIST [STRING]
		do
			analyze (Void)
			if attached expansion_parts as l_x_parts then
				create {ARRAYED_LIST [STRING]} Result.make (l_x_parts.count)
				from
					l_x_parts.start
				until
					l_x_parts.after
				loop
					if l_x_parts.item.is_query then
						Result.append (l_x_parts.item.variable_names)
					end
					l_x_parts.forth
				end
			else
				create {ARRAYED_LIST [STRING]} Result.make (0)
			end
		end

feature -- Builder

	string (a_ht: HASH_TABLE [detachable ANY, STRING]): STRING
		local
			tpl: like template
			exp: URI_TEMPLATE_EXPRESSION
			p,q: INTEGER
		do
			analyze (Void)
			tpl := template
			if attached expansion_parts as l_x_parts then
				create Result.make (tpl.count)
				from
					l_x_parts.start
					p := 1
				until
					l_x_parts.after
				loop
					q := l_x_parts.item.position
						--| Added inter variable text
					Result.append (tpl.substring (p, q - 1))
						--| Expand variables ...
					exp := l_x_parts.item
					exp.append_to_string (a_ht, Result)

					p := q + l_x_parts.item.expression.count + 2

					l_x_parts.forth
				end
				Result.append (tpl.substring (p, tpl.count))
			else
				create Result.make_from_string (tpl)
			end
		end

	url_encoder: URL_ENCODER
		once
			create Result
		end

feature -- Analyze

	match (a_uri: STRING): detachable TUPLE [path_variables: HASH_TABLE [STRING, STRING]; query_variables: HASH_TABLE [STRING, STRING]]
		local
			b: BOOLEAN
			tpl: like template
			l_offset: INTEGER
			p,q: INTEGER
			exp: URI_TEMPLATE_EXPRESSION
			vn, s,t: STRING
			vv: STRING
			l_vars, l_path_vars, l_query_vars: HASH_TABLE [STRING, STRING]
		do
				--| Extract expansion parts  "\\{([^\\}]*)\\}"
			analyze (Void)
			if attached expansion_parts as l_x_parts then
				create l_path_vars.make (l_x_parts.count)
				create l_query_vars.make (l_x_parts.count)
				l_vars := l_path_vars
				tpl := template
				b := True
				from
					l_x_parts.start
					p := 1
					l_offset := 0
				until
					l_x_parts.after or not b
				loop
					exp := l_x_parts.item
					vn := exp.expression
					q := exp.position
						--| Check text between vars
					if q > p then
						t := tpl.substring (p, q - 1)
						s := a_uri.substring (p + l_offset, q + l_offset - 1)
						b := s.same_string (t)
						p := q + vn.count + 2
					end
						--| Check related variable
					if not vn.is_empty then
						if exp.is_query then
							l_vars := l_query_vars
						else
							l_vars := l_path_vars
						end

						inspect vn[1]
						when '?' then
							import_form_style_parameters_into (a_uri.substring (q + l_offset + 1, a_uri.count), l_vars)
						when ';' then
							import_path_style_parameters_into (a_uri.substring (q + l_offset, a_uri.count), l_vars)
						else
							vv := next_path_variable_value (a_uri, q + l_offset)
							l_vars.force (vv, vn)
							l_offset := l_offset + vv.count - (vn.count + 2)
						end
					end
					l_x_parts.forth
				end
				if b then
					Result := [l_path_vars, l_query_vars]
				end
			end
		end

	analyze (a_handler: detachable URI_TEMPLATE_HANDLER)
		local
			l_x_parts: like expansion_parts
			c: CHARACTER
			i,p,n: INTEGER
			tpl: like template
			in_x: BOOLEAN
			in_query: BOOLEAN
			x: STRING
			exp: URI_TEMPLATE_EXPRESSION
		do
			l_x_parts := expansion_parts
			if l_x_parts = Void then
				tpl := template

					--| Extract expansion parts  "\\{([^\\}]*)\\}"
				create {ARRAYED_LIST [like expansion_parts.item]} l_x_parts.make (tpl.occurrences ('{'))
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
							l_x_parts.force (exp)
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
				expansion_parts := l_x_parts
			end
		end

feature {NONE} -- Implementation

	expansion_parts: detachable LIST [URI_TEMPLATE_EXPRESSION]
			-- Expansion parts

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

	comma_separated_variable_names (s: STRING): LIST [STRING]
		do
			Result := s.split (',')
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
