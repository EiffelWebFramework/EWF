note
	description : "[
			Objects that represents the output stream
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_OUTPUT_STREAM

feature -- Basic operation

	put_string (s: STRING_8)
			-- Write `s' into the output stream
		require
			s_not_empty: s /= Void and then not s.is_empty
		deferred
		end

	flush
			-- Flush the output stream	
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
