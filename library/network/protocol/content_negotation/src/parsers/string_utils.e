note
	description: "Summary description for {STRING_UTILS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STRING_UTILS

feature {NONE} -- Implementation

	mime_type (s: READABLE_STRING_8): READABLE_STRING_8
		local
			p: INTEGER
		do
			p := s.index_of (';', 1)
			if p > 0 then
				Result := trim (s.substring (1, p - 1))
			else
				Result := trim (s.string)
			end
		end

	trim (a_string: READABLE_STRING_8): READABLE_STRING_8
			-- trim whitespace from the beginning and end of a string
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
