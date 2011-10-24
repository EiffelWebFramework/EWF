note
	description: "Summary description for {WSF_VALUE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALUE

inherit
	DEBUG_OUTPUT

convert
	as_string: {READABLE_STRING_32, STRING_32}

feature -- Access

	name: READABLE_STRING_32
			-- Parameter name
		deferred
		end

feature -- Helper

	same_string (a_other: READABLE_STRING_GENERAL): BOOLEAN
			-- Does `a_other' represent the same string as `Current'?	
		deferred
		end

	is_case_insensitive_equal (a_other: READABLE_STRING_8): BOOLEAN
			-- Does `a_other' represent the same case insensitive string as `Current'?
		deferred
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make_from_string (name.as_string_8 + "=" + as_string.as_string_8)
		end

feature -- Query

	as_string: STRING_32
		deferred
		end

feature {NONE} -- Implementation

	url_decoded_string (s: READABLE_STRING_8): READABLE_STRING_32
			-- Decoded url-encoded string `s'
		do
			Result := url_encoder.decoded_string (s)
		end

	url_encoder: URL_ENCODER
		once
			create {UTF8_URL_ENCODER} Result --| Chrome is UTF-8 encoding the non ascii in query
		end

feature -- Visitor

	process (vis: WSF_VALUE_VISITOR)
		deferred
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
