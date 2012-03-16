note
	description: "Summary description for {WSF_STRING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STRING

inherit
	WSF_VALUE
		redefine
			same_string,
			is_case_insensitive_equal
		end

create
	make

convert
	string_representation: {READABLE_STRING_32, STRING_32}

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_8; a_string: READABLE_STRING_8)
		do
			name := url_decoded_string (a_name)
			string := url_decoded_string (a_string)

			url_encoded_name := a_name
			url_encoded_string := a_string
		end

feature -- Access

	name: READABLE_STRING_32

	string: READABLE_STRING_32

	url_encoded_name: READABLE_STRING_8

	url_encoded_string: READABLE_STRING_8

feature -- Element change

	change_name (a_name: like name)
		do
			name := url_decoded_string (a_name)
			url_encoded_name := a_name
		ensure then
			a_name.same_string (url_encoded_name)
		end

feature -- Status report

	is_string: BOOLEAN = True
			-- Is Current as a WSF_STRING representation?

feature -- Helper

	same_string (a_other: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_other' represent the same string as `Current'?	
		do
			Result := string.same_string_general (a_other)
		end

	is_case_insensitive_equal (a_other: READABLE_STRING_8): BOOLEAN
			-- Does `a_other' represent the same case insensitive string as `Current'?
		local
			v: like string
		do
			v := string
			if v = a_other then
				Result := True
			elseif v.is_valid_as_string_8 then
				Result := v.is_case_insensitive_equal (a_other)
			end
		end

feature -- Conversion

	string_representation: STRING_32
		do
			create Result.make_from_string (string)
		end

feature -- Visitor

	process (vis: WSF_VALUE_VISITOR)
		do
			vis.process_string (Current)
		end

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
