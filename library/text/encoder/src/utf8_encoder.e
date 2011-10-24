note
	description: "[
				Summary description for {UTF8_ENCODER}.
				
				see: http://en.wikipedia.org/wiki/UTF-8
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	UTF8_ENCODER

inherit
	ENCODER [STRING_32, STRING_8]

	UNICODE_CONVERSION
		export
			{NONE} all
			{ANY} is_valid_utf8
		undefine
			is_little_endian
		end

	PLATFORM
		export
			{NONE} all
		end

feature -- Access

	name: READABLE_STRING_8
		do
			create {IMMUTABLE_STRING_8} Result.make_from_string ("UTF8-encoded")
		end

feature -- Status report

	has_error: BOOLEAN

feature -- Encoder

	encoded_string (s: STRING_32): STRING_8
			-- UTF8-encoded value of `s'.
		do
			Result := utf32_to_utf8 (s)
			has_error := not last_conversion_successful
		end

feature -- Decoder

	decoded_string (v: STRING_8): STRING_32
			-- The UTF8-encoded equivalent of the given string
		do
			Result := utf8_to_utf32 (v)
			has_error := not last_conversion_successful
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
