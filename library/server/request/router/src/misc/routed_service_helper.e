note
	description: "Summary description for {ROUTED_SERVICE_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROUTED_SERVICE_HELPER

inherit
	ANY

feature -- Helper

	execute_content_type_not_allowed (req: WSF_REQUEST; res: WSF_RESPONSE; a_content_types: detachable ARRAY [STRING]; a_uri_formats: detachable ARRAY [STRING])
		local
			accept_s, uri_s: detachable STRING
			i, n: INTEGER
		do
			if a_content_types /= Void then
				create accept_s.make (10)
				from
					i := a_content_types.lower
					n := a_content_types.upper
				until
					i > n
				loop
					accept_s.append_string (a_content_types[i])
					if i < n then
						accept_s.append_character (',')
						accept_s.append_character (' ')
					end
					i := i + 1
				end
			else
				accept_s := "*/*"
			end

			if a_uri_formats /= Void then
				create uri_s.make (10)
				from
					i := a_uri_formats.lower
					n := a_uri_formats.upper
				until
					i > n
				loop
					uri_s.append_string (a_uri_formats[i])
					if i < n then
						uri_s.append_character (',')
						uri_s.append_character (' ')
					end
					i := i + 1
				end
			end
			res.set_status_code ({HTTP_STATUS_CODE}.unsupported_media_type)
			res.write_header ({HTTP_STATUS_CODE}.unsupported_media_type, << ["Content-Type", "text/plain"], ["Accept", accept_s]>>)
			if accept_s /= Void then
				res.write_string ("Unsupported request content-type, Accept: " + accept_s + "%N")
			end
			if uri_s /= Void then
				res.write_string ("Unsupported request format from the URI: " + uri_s + "%N")
			end
		end

	execute_request_method_not_allowed (req: WSF_REQUEST; res: WSF_RESPONSE; a_methods: ITERABLE [STRING])
		local
			s: STRING
		do
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			create s.make (25)
			across
				a_methods as c
			loop
				if not s.is_empty then
					s.append_character (',')
					s.append_character (' ')
				end
				s.append_string (c.item)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			res.write_header ({HTTP_STATUS_CODE}.method_not_allowed, <<
						["Content-Type", {HTTP_MIME_TYPES}.text_plain],
						["Allow", s]
					>>)
			res.write_string ("Unsupported request method, Allow: " + s + "%N")
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
