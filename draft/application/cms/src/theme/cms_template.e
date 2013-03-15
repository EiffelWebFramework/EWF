note
	description: "Summary description for {WSF_CMS_PAGE_TEMPLATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_TEMPLATE

feature -- Access

	theme: CMS_THEME
		deferred
		end

	variables: HASH_TABLE [detachable ANY, STRING]
		deferred
		end

	prepare  (page: CMS_HTML_PAGE)
		deferred
		end

	to_html (page: CMS_HTML_PAGE): STRING
		deferred
		end

feature {NONE} -- Implementation		

	apply_template_engine (s: STRING_8)
		local
			p,n: INTEGER
			k: STRING
			sv: detachable STRING
		do
			from
				n := s.count
				p := 1
			until
				p = 0
			loop
				p := s.index_of ('$', p)
				if p > 0 then
					k := next_identifier (s, p + 1)
					s.remove_substring (p, p + k.count)
					sv := Void
					if attached variables.item (k) as l_value then

						if attached {STRING_8} l_value as s8 then
							sv := s8
						elseif attached {STRING_32} l_value as s32 then
							sv := s32.as_string_8 -- FIXME: use html encoder
						else
							sv := l_value.out
						end
						s.insert_string (sv, p)
						p := p + sv.count
					else
						debug
							s.insert_string ("$" + k, p)
						end
					end
				end
			end
		end

	next_identifier (s: STRING; a_index: INTEGER): STRING
		local
			i: INTEGER
		do
			from
				i := a_index
			until
				not (s[i].is_alpha_numeric or s[i] = '_' or s[i] = '.')
			loop
				i := i + 1
			end
			Result := s.substring (a_index, i - 1)
		end

end
