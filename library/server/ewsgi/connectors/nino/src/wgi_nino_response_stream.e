note
	description: "[
			WGI Response implemented using stream buffer

		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_NINO_RESPONSE_STREAM

inherit
	WGI_RESPONSE_STREAM
		redefine
			put_header_text
		end

create
	make

feature -- Header output operation		

	put_header_text (a_text: READABLE_STRING_8)
		do
			write (a_text)
			-- Nino does not support persistent connection for now
			write ("Connection: close")
			write (crlf)

			-- end of headers
			write (crlf)
			header_committed := True
		end

;note
	copyright: "2011-2012, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
