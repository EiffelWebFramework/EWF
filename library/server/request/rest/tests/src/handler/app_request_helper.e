note
	description: "Summary description for {APP_REQUEST_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	APP_REQUEST_HELPER

feature -- Helpers

	send_error (a_path: STRING; a_error_id: INTEGER; a_error_name: STRING; a_error_message: detachable STRING; ctx: APP_REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			s: STRING
			i,nb: INTEGER
			rep_data: REST_RESPONSE
		do
			res.set_status_code ({HTTP_STATUS_CODE}.expectation_failed)
			create rep_data.make (a_path)
			rep_data.headers.put_content_type_text_plain

			create s.make_empty
			inspect ctx.format_id
			when {HTTP_FORMAT_CONSTANTS}.json then
				rep_data.headers.put_content_type_text_plain
				s := "{%"application%": %"" + a_path + "%""
				s.append_string (", %"error%": {")
				s.append_string ("%"id%": " + a_error_id.out)
				s.append_string (",%"name%": %"" + a_error_name + "%"")
				if a_error_message /= Void then
					s.append_string (",%"message%": %"")

					if a_error_message.has ('%N') then
						from
							i := s.count
							s.append_string (a_error_message)
							nb := s.count
						until
							i > nb
						loop
							inspect s[i]
							when '%R' then
								if s.valid_index (i+1) and then s[i+1] = '%N' then
									s[i] := '\'
									s[i+1] := 'n'
									i := i + 1
								end
							when '%N' then
								s.insert_character ('\', i)
								s[i] := 'n'
							else
							end
							i := i + 1
						end
					else
						s.append_string (a_error_message)
					end
					s.append_string ("%"")
				end

				s.append_string ("}") -- end error
				s.append_string ("}") -- end global object
				rep_data.set_message (s)
			when {HTTP_FORMAT_CONSTANTS}.xml then
				rep_data.headers.put_content_type_text_xml
				s := "<application path=%"" + a_path + "%"><error id=%"" + a_error_id.out + "%" name=%""+ a_error_name +"%">"
				if a_error_message /= Void then
					s.append_string (a_error_message)
				end
				s.append_string ("</error></application>")
				rep_data.set_message (s)
			when {HTTP_FORMAT_CONSTANTS}.html then
				rep_data.headers.put_content_type_text_html
				s := "<strong>application</strong>: " + a_path + "<br/>%N<strong>Error</strong> (" + a_error_id.out + ") %"" + a_error_name + "%"<br/>%N"
				if a_error_message /= Void then
					s.append_string ("<blockquote>" + a_error_message + "</blockquote>")
				end
				rep_data.set_message (s)
			when {HTTP_FORMAT_CONSTANTS}.text then -- Default
				s := "Application: " + a_path + "<br/>%N"
				s.append_string ("Error (" + a_error_id.out + ") %"" + a_error_name + "%"%N")
				if a_error_message /= Void then
					s.append_string ("%T" + a_error_message + "%N")
				end
				rep_data.set_message (s)
			end
			rep_data.send (res)
			rep_data.recycle
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
