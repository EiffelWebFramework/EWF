note
	description: "Summary description for {REQUEST_HANDLER_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_HANDLER_CONTEXT

feature -- Access

	request: EWSGI_REQUEST
			-- Associated request

	path: STRING
			-- ???

	request_format: detachable STRING
			-- Request format based on `Content-Type'.
		local
			s: detachable STRING
		do
			s := request.environment.content_type
			if s = Void then
			elseif s.same_string ({HTTP_CONSTANTS}.json_text) then
				Result := {HTTP_FORMAT_CONSTANTS}.json_name
			elseif s.same_string ({HTTP_CONSTANTS}.json_app) then
				Result := {HTTP_FORMAT_CONSTANTS}.json_name
			elseif s.same_string ({HTTP_CONSTANTS}.xml_text) then
				Result := {HTTP_FORMAT_CONSTANTS}.xml_name
			elseif s.same_string ({HTTP_CONSTANTS}.html_text) then
				Result := {HTTP_FORMAT_CONSTANTS}.html_name
			elseif s.same_string ({HTTP_CONSTANTS}.plain_text) then
				Result := {HTTP_FORMAT_CONSTANTS}.text_name
			end
		end

feature -- Query	

	path_parameter (a_name: STRING): detachable STRING_32
			-- Parameter value for path variable `a_name'
		deferred
		end

	query_parameter (a_name: STRING): detachable STRING_32
			-- Parameter value for query variable `a_name'	
			--| i.e after the ? character
		deferred
		end

	parameter (a_name: STRING): detachable STRING_32
			-- Any parameter value for variable `a_name'
			-- URI template parameter and query parameters
		do
			Result  := query_parameter (a_name)
			if Result = Void then
				Result := path_parameter (a_name)
			end
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
