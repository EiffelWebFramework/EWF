note
	description: "Summary description for {CMS_PAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_PAGER

create
	make

feature {NONE} -- Initialization

	make (tpl: READABLE_STRING_8; a_lower, a_upper: NATURAL_64; a_step: NATURAL_64)
		do
			create template.make (tpl)
			lower := a_lower
			upper := a_upper
			step := a_step
		end

feature -- Change

	set_active_range (a_lower, a_upper: NATURAL_64)
		do
			if a_upper = 0 then
				active_range := [{NATURAL_64} 1, {NATURAL_64} 0]
			elseif a_lower > 0 and a_lower <= a_upper then
				active_range := [a_lower, a_upper]
			else
				active_range := Void
			end
		ensure
			valid_range: attached active_range as rg implies (rg.upper = 0 or else rg.lower <= rg.upper)
		end

feature -- Access

	template: URI_TEMPLATE

	lower: NATURAL_64

	upper: NATURAL_64

	step: NATURAL_64

	active_range: detachable TUPLE [lower_index, upper_index: NATURAL_64]

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
		local
			l_step: INTEGER
			nb: INTEGER
			curr: INTEGER
			n, i: INTEGER
			tb: HASH_TABLE [detachable ANY, STRING_8]
		do
			create Result.make (32)
			Result.append ("<div")
			Result.append_character ('>')
			nb := ((upper - lower) // step).to_integer_32 + 1
			if attached active_range as rg then
				if rg.upper_index = 0 then
					-- all
				else
					curr := ((rg.lower_index - lower) // step).to_integer_32
					if step * curr.to_natural_64 < rg.lower_index then
						curr := curr + 1
					end
				end
			end

			l_step := step.to_integer_32
			create tb.make (2)
			tb.force (1, "lower")
			tb.force (step, "upper")
			if curr > 1 then
				if curr > 2 then
					tb.force (1, "lower")
					tb.force (l_step, "upper")

					Result.append_character (' ')
					Result.append (a_theme.link ("<<", template.expanded_string (tb), Void))
					Result.append_character (' ')
				end

				tb.force ((curr - 1) * l_step + 1, "lower")
				tb.force ((curr    ) * l_step    , "upper")

				Result.append_character (' ')
				Result.append (a_theme.link ("<", template.expanded_string (tb), Void))
				Result.append_character (' ')
			end

			from
				i := (curr - 1).max (1)
				n := 5
			until
				n = 0 or i > nb
			loop
				Result.append_character (' ')

				tb.force ((i - 1) * l_step + 1, "lower")
				tb.force ((i    ) * l_step    , "upper")

				if i = curr then
					Result.append ("<strong>")
				end
				Result.append (a_theme.link (i.out, template.expanded_string (tb), Void))
				if i = curr then
					Result.append ("</strong>")
				end

				Result.append_character (' ')

				i := i + 1
				n := n - 1
			end

			if curr < nb then
				Result.append_character (' ')
				tb.force ((curr    ) * l_step + 1, "lower")
				tb.force ((curr + 1) * l_step    , "upper")

				Result.append (a_theme.link (">", template.expanded_string (tb), Void))
				Result.append_character (' ')

				if curr + 1 < nb then
					tb.force ((nb - 1) * l_step + 1, "lower")
					tb.force ( upper , "upper")

					Result.append_character (' ')
					Result.append (a_theme.link (">>", template.expanded_string (tb), Void))
					Result.append_character (' ')
				end
			end

			Result.append ("</div>")
			debug
				Result.append ("curr=" + curr.out +" step=" + step.out + " nb=" + nb.out)
			end
		end

end
