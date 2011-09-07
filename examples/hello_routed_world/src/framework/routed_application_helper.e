note
	description: "Summary description for {ROUTED_APPLICATION_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROUTED_APPLICATION_HELPER

inherit
	ANY

	HTTP_FORMAT_CONSTANTS
		export
			{NONE} all
		end

feature -- Helper

	execute_content_type_not_allowed (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER; a_content_types: detachable ARRAY [STRING]; a_uri_formats: detachable ARRAY [STRING])
		local
			s, uri_s: detachable STRING
			i, n: INTEGER
			h: EWF_HEADER
		do
			create h.make
			h.put_status ({HTTP_STATUS_CODE}.unsupported_media_type)
			h.put_content_type_text_plain

			if a_content_types /= Void then
				create s.make (10)
				from
					i := a_content_types.lower
					n := a_content_types.upper
				until
					i > n
				loop
					s.append_string (a_content_types[i])
					if i < n then
						s.append_character (',')
						s.append_character (' ')
					end
					i := i + 1
				end
				h.put_header_key_value ("Accept", s)
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
			res.write_headers_string (h.string)
			if s /= Void then
				res.write_string ("Unsupported request content-type, Accept: " + s + "%N")
			end
			if uri_s /= Void then
				res.write_string ("Unsupported request format from the URI: " + uri_s + "%N")
			end
		end

	execute_method_not_allowed (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER; a_methods: ARRAY [STRING])
		local
			s: STRING
			i, n: INTEGER
		do
			create s.make (10)
			from
				i := a_methods.lower
				n := a_methods.upper
			until
				i > n
			loop
				s.append_string (a_methods[i])
				if i < n then
					s.append_character (',')
					s.append_character (' ')
				end
				i := i + 1
			end

			res.write_header ({HTTP_STATUS_CODE}.method_not_allowed, <<
						["Content-Type", {HTTP_CONSTANTS}.plain_text],
						["Allow", s]
					>>)
			res.write_string ("Unsupported request method, Allow: " + s + "%N")
		end

feature -- Context helper

	request_format_id (ctx: REQUEST_HANDLER_CONTEXT; a_format_variable_name: detachable STRING; content_type_supported: detachable ARRAY [STRING]): INTEGER
			-- Format id for the request based on {HTTP_FORMAT_CONSTANTS}
		local
			l_format: detachable STRING_8
		do
			if a_format_variable_name /= Void and then attached ctx.parameter (a_format_variable_name) as ctx_format then
				l_format := ctx_format.as_string_8
			else
				l_format := content_type_to_request_format (ctx.request_content_type (content_type_supported))
			end
			if l_format /= Void then
				Result := format_id (l_format)
			else
				Result := 0
			end
		end

	content_type_to_request_format (a_content_type: detachable READABLE_STRING_8): detachable STRING
			-- `a_content_type' converted into a request format name
		do
			if a_content_type /= Void then
				if a_content_type.same_string ({HTTP_CONSTANTS}.json_text) then
					Result := {HTTP_FORMAT_CONSTANTS}.json_name
				elseif a_content_type.same_string ({HTTP_CONSTANTS}.json_app) then
					Result := {HTTP_FORMAT_CONSTANTS}.json_name
				elseif a_content_type.same_string ({HTTP_CONSTANTS}.xml_text) then
					Result := {HTTP_FORMAT_CONSTANTS}.xml_name
				elseif a_content_type.same_string ({HTTP_CONSTANTS}.html_text) then
					Result := {HTTP_FORMAT_CONSTANTS}.html_name
				elseif a_content_type.same_string ({HTTP_CONSTANTS}.plain_text) then
					Result := {HTTP_FORMAT_CONSTANTS}.text_name
				end
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
