note
	description : "[
			Objects that represents the output stream
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_OUTPUT_STREAM

feature -- Core operation

	put_string (s: STRING_8)
			-- Write `s' into the output stream
		require
			s_not_empty: s /= Void and then not s.is_empty
		deferred
		end

	flush
			-- Flush the output stream	
		do
		end

feature -- Status writing

	put_status_line (a_code: INTEGER)
			-- Put status code line for `a_code'
			--| Note this is a default implementation, and could be redefined
			--| for instance in relation to NPH CGI script
		deferred
		end

feature -- Basic operation

	put_substring (s: STRING; start_index, end_index: INTEGER)
			-- Write `s[start_index:end_index]' into the output stream
		require
			s_not_empty: s /= Void and then not s.is_empty
		do
			put_string (s.substring (start_index, end_index))
		end

	put_header_line (s: STRING)
			-- Send `s' to http client as header line
		do
			put_string (s)
			put_string ("%R%N")
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
