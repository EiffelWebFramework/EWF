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

	make (l: ITERABLE [STRING_32])
			-- Initialize
		do
			list := l
		end

feature -- Implementation

	autocompletion (input: STRING_32): JSON_ARRAY
			-- Implementation
		local
			o: WSF_JSON_OBJECT
		do
			create Result.make_array
			across
				list as c
			loop
				if c.item.as_lower.has_substring (input.as_lower) then
					create o.make
					o.put_string (c.item, "value")
					Result.add (o)
				end
			end
		end

	list: ITERABLE [STRING_32]
			-- List containing suggestions

end
