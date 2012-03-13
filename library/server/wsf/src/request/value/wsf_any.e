note
	description: "Summary description for {WSF_ANY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ANY

inherit
	WSF_VALUE

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_8; a_value: like item)
		do
			name := url_decoded_string (a_name)
			url_encoded_name := a_name
			item := a_value
		end

feature -- Access

	name: READABLE_STRING_32

	url_encoded_name: READABLE_STRING_8

	item: detachable ANY

feature -- Element change

	change_name (a_name: like name)
		do
			name := url_decoded_string (a_name)
		ensure then
			a_name.same_string (url_encoded_name)
		end

feature -- Status report

	is_string: BOOLEAN = False
			-- Is Current as a WSF_STRING representation?

feature -- Query

	string_representation: STRING_32
			-- String representation of Current
			-- if possible
		do
			if attached item as i then
				Result := i.generating_type
			else
				Result := "Void"
			end
		end

feature -- Visitor

	process (vis: WSF_VALUE_VISITOR)
		do
			vis.process_any (Current)
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
