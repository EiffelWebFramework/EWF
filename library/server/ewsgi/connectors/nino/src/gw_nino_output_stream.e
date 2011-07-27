note
	description: "Summary description for {GW_NINO_OUTPUT_STREAM}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_NINO_OUTPUT_STREAM

inherit
	EWSGI_OUTPUT_STREAM

	HTTP_STATUS_CODE_MESSAGES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_nino_output: like nino_output)
		do
			set_nino_output (a_nino_output)
		end

feature {GW_NINO_CONNECTOR, EWSGI_APPLICATION} -- Nino

	set_nino_output (o: like nino_output)
		do
			nino_output := o
		end

	nino_output: HTTP_OUTPUT_STREAM

feature -- Status writing

	put_status_line (a_code: INTEGER)
			-- Put status code line for `a_code'
			--| Note this is a default implementation, and could be redefined
			--| for instance in relation to NPH CGI script
		local
			s: STRING
		do
			create s.make (16)
			s.append ({HTTP_CONSTANTS}.http_version_1_1)
			s.append_character (' ')
			s.append_integer (a_code)
			if attached http_status_code_message (a_code) as l_status_message then
				s.append_character (' ')
				s.append_string (l_status_message)
			end
			put_header_line (s)
		end

feature -- Basic operation

	put_string (s: STRING_8)
			-- Send `s' to http client
		do
			debug ("nino")
				print (s)
			end
			nino_output.put_string (s)
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
