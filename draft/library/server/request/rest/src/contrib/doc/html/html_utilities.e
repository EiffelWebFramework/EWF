note
	description: "Summary description for {HTML_UTILITIES}."
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_UTILITIES

feature -- Encoding

	html_special_chars_encoded_string (s: STRING): STRING
		local
			c: CHARACTER
			i,n: INTEGER
		do
			from
				i := 1
				n := s.count
				create Result.make (n + 10)
			until
				i > n
			loop
				c := s[i]
				inspect c
				when '&' then
					Result.append_string ("&amp;")
				when '%"' then
					Result.append_string ("&quot;")
				when '%'' then
					Result.append_string ("&#039;")
				when '<' then
					Result.append_string ("&lt;")
				when '>' then
					Result.append_string ("&gt;")
				else
					Result.extend (c)
				end
				i := i + 1
			end
		end

feature -- Helpers

	strings_to_string (lst: LIST [STRING]; sep: STRING): STRING
		do
			create Result.make_empty
			if lst.count > 0 then
				from
					lst.start
				until
					lst.after
				loop
					Result.append_string (lst.item)
					Result.append_string (sep)
					lst.forth
				end
			end
		end

	attributes_to_string (atts: LIST [TUPLE [name: STRING; value: STRING]]): STRING
		do
			create Result.make_empty
			if atts.count > 0 then
				from
					atts.start
				until
					atts.after
				loop
					Result.append_character (' ')
					Result.append_string (atts.item.name)
					Result.append_character ('=')
					Result.append_character ('%"')
					Result.append_string (html_special_chars_encoded_string (atts.item.value))
					Result.append_character ('%"')
					atts.forth
				end
			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
