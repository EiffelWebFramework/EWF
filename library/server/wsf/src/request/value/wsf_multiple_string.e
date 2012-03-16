note
	description: "Summary description for {WSF_MULTIPLE_STRING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MULTIPLE_STRING

inherit
	WSF_VALUE
		redefine
			as_string
		end

	ITERABLE [WSF_STRING]

create
	make_with_value,
	make_with_array,
	make_with_string

feature {NONE} -- Initialization

	make_with_value (a_value: WSF_VALUE)
		do
			name := a_value.name
			create {LINKED_LIST [WSF_STRING]} string_values.make
			add_value (a_value)
		end

	make_with_array (arr: ARRAY [WSF_VALUE])
		require
			arr_not_empty: not arr.is_empty
			all_same_name: across arr as c all c.item.name.same_string (arr[arr.lower].name) end
		local
			i,up: INTEGER
		do
			up := arr.upper
			i := arr.lower
			make_with_value (arr[i])
			from
				i := i + 1
			until
				i > up
			loop
				add_value (arr[i])
				i := i + 1
			end
		end

	make_with_string (a_name: like name; a_string: READABLE_STRING_32)
		do
			make_with_value (create {WSF_STRING}.make (a_name, a_string))
		end

feature -- Access

	name: READABLE_STRING_32

	string_values: LIST [WSF_STRING]

	first_string_value: WSF_STRING
		do
			Result := string_values.first
		end

feature -- Element change

	change_name (a_name: like name)
		do
			name := a_name
		ensure then
			a_name.same_string (name)
		end

feature -- Status report

	is_string: BOOLEAN
			-- Is Current as a WSF_STRING representation?
		do
			Result := string_values.count = 1
		end

feature -- Conversion

	as_string: WSF_STRING
		do
			if string_values.count = 1 then
				Result := first_string_value
			else
				Result := Precursor
			end
		end

feature -- Traversing

	new_cursor: ITERATION_CURSOR [WSF_STRING]
		do
			Result := string_values.new_cursor
		end

feature -- Helper

	string_representation: STRING_32
		do
			if string_values.count = 1 then
				create Result.make_from_string (first_string_value)
			else
				create Result.make_from_string ("[")
				across
					string_values as c
				loop
					if Result.count > 1 then
						Result.append_character (',')
					end
					Result.append_string (c.item)
				end
				Result.append_character (']')
			end
		end

feature -- Element change

	add_value (a_value: WSF_VALUE)
		require
			same_name: a_value.name.same_string (name)
		do
			if attached {WSF_STRING} a_value as sval then
				add_string_value (sval)
			elseif attached {WSF_MULTIPLE_STRING} a_value as slst then
				across
					slst as cur
				loop
					add_string_value (cur.item)
				end
			end
		end

	add_string_value (s: WSF_STRING)
		do
			string_values.extend (s)
		end

feature -- Visitor

	process (vis: WSF_VALUE_VISITOR)
		do
			vis.process_multiple_string (Current)
		end

invariant
	string_values_not_empty: string_values.count >= 1

note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
