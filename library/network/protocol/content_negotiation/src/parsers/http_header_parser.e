note
	description: "Summary description for {HTTP_HEADER_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTP_HEADER_PARSER

feature {NONE} -- Helpers	

	entity_value (a_str: READABLE_STRING_8): READABLE_STRING_8
			-- `s' with any trailing parameters stripped
		local
			p: INTEGER
		do
			p := a_str.index_of (';', 1)
			if p > 0 then
				Result := trim (a_str.substring (1, p - 1))
			else
				Result := trim (a_str.string)
			end
		end

	trim (a_string: READABLE_STRING_8): STRING_8
			-- trim whitespace from the beginning and end of a string
			-- `a_string'
		require
			valid_argument : a_string /= Void
		do
			create Result.make_from_string (a_string)
			Result.left_adjust
			Result.right_adjust
		ensure
			result_trimmed: a_string.has_substring (Result)
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
