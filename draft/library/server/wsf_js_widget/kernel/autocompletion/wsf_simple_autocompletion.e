note
	description: "Summary description for {WSF_SIMPLE_AUTOCOMPLETION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_SIMPLE_AUTOCOMPLETION

inherit
	WSF_AUTOCOMPLETION

create
	make

feature {NONE} -- Initialization

	make (a_list: ITERABLE [READABLE_STRING_32])
			-- Initialize with collection `a_list'.
		do
			list := a_list
		end

feature -- Access

	list: ITERABLE [READABLE_STRING_32]
			-- List containing suggestions		

feature -- Implementation

	autocompletion (a_input: READABLE_STRING_GENERAL): JSON_ARRAY
			-- <Precursor>
		local
			o: WSF_JSON_OBJECT
			l_lowered_input: READABLE_STRING_GENERAL
			l_lowered_item: READABLE_STRING_GENERAL
		do
			create Result.make_empty
			l_lowered_input := a_input.as_lower
 			across
				list as c
			loop
				l_lowered_item := c.item.as_lower
				if l_lowered_item.has_substring (l_lowered_input) then
					create o.make
					o.put_string (c.item, "value")
					Result.add (o)
				end
			end
		end

;note
	copyright: "2011-2015, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
