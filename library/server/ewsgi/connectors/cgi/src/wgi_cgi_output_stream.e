note
	description: "Summary description for WGI_CGI_OUTPUT_STREAM."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_CGI_OUTPUT_STREAM

inherit
	WGI_OUTPUT_STREAM
		rename
			put_string as put_readable_string_8
		end

	CONSOLE
		rename
			make as console_make
		end

	HTTP_STATUS_CODE_MESSAGES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_open_stdout ("stdout")
		end

feature -- Status writing

	put_status_line (a_code: INTEGER)
			-- Put status code line for `a_code'
			--| Note this is a default implementation, and could be redefined
			--| for instance in relation to NPH CGI script
		local
			s: STRING
		do
			if a_code /= 200 then
				create s.make (16)
				s.append ("Status:")
				s.append_character (' ')
				s.append_integer (a_code)
				if attached http_status_code_message (a_code) as l_status_message then
					s.append_character (' ')
					s.append_string (l_status_message)
				end
				put_header_line (s)
			end
		end

	put_readable_string_8 (s: READABLE_STRING_8)
			-- Write `s' at end of default output.
		local
			ext: C_STRING
		do
			if s.count > 0 then
				create ext.make (s)
				console_ps (file_pointer, ext.managed_data.item, s.count)
			end
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
