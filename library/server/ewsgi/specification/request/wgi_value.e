note
	description: "Summary description for {WGI_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_VALUE

convert
	as_string: {READABLE_STRING_32, STRING_32}

feature -- Access

	name: READABLE_STRING_GENERAL
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

feature -- Query

	as_string: STRING_32
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
