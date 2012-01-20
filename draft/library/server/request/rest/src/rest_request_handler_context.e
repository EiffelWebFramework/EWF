note
	description: "Summary description for {REST_REQUEST_HANDLER_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REST_REQUEST_HANDLER_CONTEXT

inherit
	REQUEST_HANDLER_CONTEXT

feature -- Accept: Content-Type

	accepted_content_type: detachable READABLE_STRING_8
		do
			if internal_accepted_content_type = Void then
				get_accepted_content_type (Void)
			end
			Result := internal_accepted_content_type
		end

	get_accepted_content_type (a_supported_content_types: detachable ARRAY [STRING_8])
		do
			if internal_accepted_content_type = Void then
				internal_accepted_content_type := request_accepted_content_type (a_supported_content_types)
			end
		end

feature -- Format name

	accepted_format_name: detachable READABLE_STRING_8
		do
			if internal_accepted_format_name = Void then
				get_accepted_format_name (Void, Void)
			end
			Result := internal_accepted_format_name
		end

	get_accepted_format_name (a_format_variable_name: detachable READABLE_STRING_8; a_supported_content_types: detachable ARRAY [STRING_8])
		do
			if internal_accepted_format_name = Void then
				internal_accepted_format_name := request_accepted_format (a_format_variable_name, a_supported_content_types)
			end
		end

feature -- Format id

	accepted_format_id: INTEGER
		do
			if internal_accepted_format_id = 0 then
				get_accepted_format_id (Void, Void)
			end
			Result := internal_accepted_format_id
		end

	get_accepted_format_id (a_format_variable_name: detachable READABLE_STRING_8; a_supported_content_types: detachable ARRAY [STRING_8])
		do
			if internal_accepted_format_id = 0 then
				internal_accepted_format_id := request_accepted_format_id (a_format_variable_name, a_supported_content_types)
			end
		end

feature {NONE} -- Constants

	Format_constants: HTTP_FORMAT_CONSTANTS
		once
			create Result
		end

feature -- Format

	request_accepted_format (a_format_variable_name: detachable READABLE_STRING_8; a_supported_content_types: detachable ARRAY [READABLE_STRING_8]): detachable READABLE_STRING_8
			-- Format id for the request based on {HTTP_FORMAT_CONSTANTS}
		do
			if a_format_variable_name /= Void and then attached string_parameter (a_format_variable_name) as ctx_format then
				Result := ctx_format.as_string_8
			else
				Result := request_format_from_content_type (request_accepted_content_type (a_supported_content_types))
			end
		end

	request_accepted_format_id (a_format_variable_name: detachable READABLE_STRING_8; a_supported_content_types: detachable ARRAY [READABLE_STRING_8]): INTEGER
			-- Format id for the request based on {HTTP_FORMAT_CONSTANTS}
		do
			if attached request_accepted_format (a_format_variable_name, a_supported_content_types) as l_format then
				Result := Format_constants.format_id (l_format)
			else
				Result := 0
			end
		end

feature {NONE} -- Format/Content type implementation		

	request_format_from_content_type (a_content_type: detachable READABLE_STRING_8): detachable READABLE_STRING_8
			-- `a_content_type' converted into a request format name
		do
			if a_content_type /= Void then
				if a_content_type.same_string ({HTTP_MIME_TYPES}.text_json) then
					Result := {HTTP_FORMAT_CONSTANTS}.json_name
				elseif a_content_type.same_string ({HTTP_MIME_TYPES}.application_json) then
					Result := {HTTP_FORMAT_CONSTANTS}.json_name
				elseif a_content_type.same_string ({HTTP_MIME_TYPES}.text_xml) then
					Result := {HTTP_FORMAT_CONSTANTS}.xml_name
				elseif a_content_type.same_string ({HTTP_MIME_TYPES}.text_html) then
					Result := {HTTP_FORMAT_CONSTANTS}.html_name
				elseif a_content_type.same_string ({HTTP_MIME_TYPES}.text_plain) then
					Result := {HTTP_FORMAT_CONSTANTS}.text_name
				end
			end
		end

feature {NONE} -- Internal

	internal_accepted_content_type: like accepted_content_type

	internal_accepted_format_id: like accepted_format_id

	internal_accepted_format_name: like accepted_format_name

;note
	copyright: "Copyright (c) 1984-2012, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
