note
	description: "Summary description for {REQUEST_URI_TEMPLATE_HANDLER_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_TEMPLATE_HANDLER_CONTEXT

inherit
	REQUEST_HANDLER_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; tpl: URI_TEMPLATE; tpl_res: URI_TEMPLATE_MATCH_RESULT; p: like path)
		do
			request := req
			uri_template := tpl
			uri_template_match := tpl_res
			path := p
		end

feature -- Access

	uri_template: URI_TEMPLATE

	uri_template_match: URI_TEMPLATE_MATCH_RESULT

feature -- Query	

	path_parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
		do
			if attached uri_template_match.url_decoded_path_variable (a_name) as s then
				create {WSF_STRING_VALUE} Result.make (a_name, s)
			end
		end

	query_parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
		do
			if attached uri_template_match.url_decoded_query_variable (a_name) as s then
				create {WSF_STRING_VALUE} Result.make (a_name, s)
			else
				Result := request.query_parameter (a_name)
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
