note
	description: "[
			WGI Response implemented using stream buffer
			for the standalone Eiffel web server connector.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_STANDALONE_RESPONSE_STREAM

inherit
	WGI_RESPONSE_STREAM
		redefine
			put_header_text
		end

create
	make

feature -- Header output operation

	put_header_text (a_text: READABLE_STRING_8)
		local
			o: like output
			l_connection: detachable STRING
			s: STRING
			i,j: INTEGER
		do
			o := output
			create s.make_from_string (a_text)

				-- FIXME: check if HTTP versions 1.0 or else.

			i := s.substring_index ("%NConnection:", 1)
			if i > 0 then
				j := s.index_of ('%R', i + 12)
			end
			if {HTTPD_SERVER}.is_persistent_connection_supported then
				if i = 0 then
					s.append ("Connection: Keep-Alive")
					s.append (o.crlf)
				end
			else
					-- standalone does not support persistent connection for now
				if j > 0 then
					l_connection := s.substring (i + 12, j - 1)
					l_connection.adjust
					if not l_connection.is_case_insensitive_equal_general ("close") then
						s.replace_substring ("Connection: close", i + 1, j - 1)
					end
				else
					s.append ("Connection: close")
					s.append (o.crlf)
				end
			end

				-- end of headers
			s.append (o.crlf)

			o.put_string (s)

			header_committed := True
		end

;note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
