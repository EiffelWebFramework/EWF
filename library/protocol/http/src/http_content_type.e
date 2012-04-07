note
	description: "[
			This class is to represent the CONTENT_TYPE value
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CONTENT_TYPE

inherit
	HTTP_MEDIA_TYPE

create
	make,
	make_from_string

convert
	make_from_string ({READABLE_STRING_8, STRING_8, IMMUTABLE_STRING_8}),
	string: {READABLE_STRING_8}

note
	copyright: "2011-2012, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
