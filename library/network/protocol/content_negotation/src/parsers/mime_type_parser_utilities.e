note
	description: "{MIME_TYPE_PARSER_UTILITIES}."
	date: "$Date$"
	revision: "$Revision$"

class
	MIME_TYPE_PARSER_UTILITIES

feature {NONE} -- Implementation

	mime_type (a_str: READABLE_STRING_8): READABLE_STRING_8
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

	trim (a_string: READABLE_STRING_8): READABLE_STRING_8
			-- trim whitespace from the beginning and end of a string
			-- `a_string'
		require
			valid_argument : a_string /= Void
		local
			l_result: STRING
		do
			l_result := a_string.as_string_8
			l_result.left_adjust
			l_result.right_adjust
			Result := l_result
		ensure
			result_same_as_argument: Result.same_string_general (a_string)
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
