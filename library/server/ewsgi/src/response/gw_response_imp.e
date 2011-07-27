note
	description: "Summary description for {GW_RESPONSE_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_RESPONSE_IMP

inherit
	GW_RESPONSE

create {GW_APPLICATION}
	make

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			output := a_output
		end

feature {NONE} -- Core output operation

	write (s: STRING)
			-- Send the content of `s'
		do
			output.put_string (s)
		end

feature {NONE} -- Status output

	write_status (a_code: INTEGER)
			-- Send status line for `a_code'
		do
			output.put_status_line (a_code)
		end

feature -- Output operation

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		do
			output.put_file_content (fn)
		end

	write_header_object (h: GW_HEADER)
			-- Send `header' to `output'.
		do
			h.send_to (Current)
		end

feature {NONE} -- Implementation: Access

	output: GW_OUTPUT_STREAM
			-- Server output channel

;note
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
