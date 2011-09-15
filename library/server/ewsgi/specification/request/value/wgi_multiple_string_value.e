note
	description: "Summary description for {WGI_MULTIPLE_STRING_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_MULTIPLE_STRING_VALUE

inherit
	WGI_VALUE

	ITERABLE [WGI_STRING_VALUE]

create
	make_with_value,
	make_with_string

feature {NONE} -- Initialization

	make_with_value (a_value: WGI_VALUE)
		do
			name := a_value.name
			create {LINKED_LIST [WGI_STRING_VALUE]} string_values.make
			add_value (a_value)
		end

	make_with_string (a_name: like name; a_string: READABLE_STRING_32)
		do
			make_with_value (create {WGI_STRING_VALUE}.make (a_name, a_string))
		end

feature -- Access

	name: READABLE_STRING_GENERAL

	string_values: LIST [WGI_STRING_VALUE]

	first_string_value: WGI_STRING_VALUE
		do
			Result := string_values.first
		end

feature -- Traversing

	new_cursor: ITERATION_CURSOR [WGI_STRING_VALUE]
		do
			Result := string_values.new_cursor
		end

feature -- Helper

	same_string (a_other: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_other' represent the same string as `Current'?	
		do
			if string_values.count = 1 then
				Result := first_string_value.same_string (a_other)
			end
		end

	is_case_insensitive_equal (a_other: READABLE_STRING_8): BOOLEAN
			-- Does `a_other' represent the same case insensitive string as `Current'?	
		do
			if string_values.count = 1 then
				Result := first_string_value.is_case_insensitive_equal (a_other)
			end
		end

	as_string: STRING_32
		do
			if string_values.count = 1 then
				create Result.make_from_string (first_string_value)
			else
				create Result.make_from_string ("[")
				across
					string_values as c
				loop
					if Result.count = 1 then
						Result.append_character (',')
					end
					Result.append_string (c.item)
				end
				Result.append_character (']')
			end
		end

feature -- Element change

	add_value (a_value: WGI_VALUE)
		require
			same_name: a_value.name.same_string (name)
		do
			if attached {WGI_STRING_VALUE} a_value as sval then
				add_string_value (sval)
			elseif attached {WGI_MULTIPLE_STRING_VALUE} a_value as slst then
				across
					slst as cur
				loop
					add_string_value (cur.item)
				end
			end
		end

	add_string_value (s: WGI_STRING_VALUE)
		do
			string_values.extend (s)
		end

invariant
	string_values_not_empty: string_values.count >= 1

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
