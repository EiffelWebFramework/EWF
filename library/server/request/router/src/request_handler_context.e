note
	description: "Summary description for {REQUEST_HANDLER_CONTEXT}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_HANDLER_CONTEXT

inherit
	ANY

	REQUEST_FORMAT_UTILITY
		export
			{NONE} all
		end

feature -- Access

	request: WSF_REQUEST
			-- Associated request

	path: READABLE_STRING_8
			-- Associated path

feature {NONE} -- Constants

	Format_constants: HTTP_FORMAT_CONSTANTS
		once
			create Result
		end

feature -- Query

	request_format (a_format_variable_name: detachable READABLE_STRING_8; content_type_supported: detachable ARRAY [READABLE_STRING_8]): detachable READABLE_STRING_8
			-- Format id for the request based on {HTTP_FORMAT_CONSTANTS}
		do
			if a_format_variable_name /= Void and then attached string_parameter (a_format_variable_name) as ctx_format then
				Result := ctx_format.as_string_8
			else
				Result := content_type_to_request_format (request_content_type (content_type_supported))
			end
		end

	request_format_id (a_format_variable_name: detachable READABLE_STRING_8; content_type_supported: detachable ARRAY [READABLE_STRING_8]): INTEGER
			-- Format id for the request based on {HTTP_FORMAT_CONSTANTS}
		do
			if attached request_format (a_format_variable_name, content_type_supported) as l_format then
				Result := Format_constants.format_id (l_format)
			else
				Result := 0
			end
		end

	content_type_to_request_format (a_content_type: detachable READABLE_STRING_8): detachable READABLE_STRING_8
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

	request_content_type (content_type_supported: detachable ARRAY [READABLE_STRING_8]): detachable READABLE_STRING_8
		local
			s: detachable READABLE_STRING_8
			i,n: INTEGER
		do
			if attached request.content_type as ct then
				Result := ct
			else
				if attached accepted_content_types (request) as l_accept_lst then
					from
						l_accept_lst.start
					until
						l_accept_lst.after or Result /= Void
					loop
						s := l_accept_lst.item
						if content_type_supported /= Void then
							from
								i := content_type_supported.lower
								n := content_type_supported.upper
							until
								i > n or Result /= Void
							loop
								if content_type_supported[i].same_string (s) then
									Result := s
								end
								i := i + 1
							end
						else
							Result := s
						end
						l_accept_lst.forth
					end
				end
			end
		end

feature -- Query	

	path_parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Parameter value for path variable `a_name'
		deferred
		end

	query_parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Parameter value for query variable `a_name'	
			--| i.e after the ? character
		deferred
		end

	parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Any parameter value for variable `a_name'
			-- URI template parameter and query parameters
		do
			Result := query_parameter (a_name)
			if Result = Void then
				Result := path_parameter (a_name)
			end
		end

feature -- String query

	string_from (a_value: detachable WSF_VALUE): detachable READABLE_STRING_32
		do
			if attached {WSF_STRING_VALUE} a_value as val then
				Result := val.string
			end
		end

	string_path_parameter (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
		do
			Result := string_from (path_parameter (a_name))
		end

	string_query_parameter (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
		do
			Result := string_from (query_parameter (a_name))
		end

	string_parameter (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
		do
			Result := string_from (parameter (a_name))
		end

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
