note
	description: "Summary description for {FLAG_AUTOCOMPLETION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FLAG_AUTOCOMPLETION

inherit

	WSF_AUTOCOMPLETION

create
	make

feature {NONE} -- Initialization

	make (l: ITERABLE [TUPLE [STRING, STRING]])
		do
			template := "<img src=%"http://www.famfamfam.com/lab/icons/flags/icons/gif/{{=flag}}.gif%"> {{=value}}";
			list := l
		end

feature -- Implementation

	autocompletion (input: STRING): JSON_ARRAY
		local
			o: JSON_OBJECT
		do
			create Result.make_array
			across
				list as c
			loop
				if attached {STRING} c.item.item (1) as first and attached {STRING} c.item.item (2) as second then
					if second.as_lower.has_substring (input.as_lower) then
						create o.make
						o.put (create {JSON_STRING}.make_json (first), "flag")
						o.put (create {JSON_STRING}.make_json (second), "value")
						Result.add (o)
					end
				end
			end
		end

	list: ITERABLE [TUPLE [STRING, STRING]]

end
