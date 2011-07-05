note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	GW_INPUT_STREAM

feature -- Access

	last_string: STRING_8
			-- Last read string from stream

feature -- Basic operation

	read_stream (n: INTEGER)
		require
			n_positive: n > 0
		deferred
		ensure
			at_max_n: last_string.count <= n
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
