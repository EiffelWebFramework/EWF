note
	description: "Summary description for {REQUEST_URI_HANDLER_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_HANDLER_CONTEXT

inherit
	REQUEST_HANDLER_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (req: WGI_REQUEST; p: like path)
		do
			request := req
			path := p
		end

feature -- Query	

	path_parameter (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE
		do
		end

	query_parameter (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE
		do
			Result := request.query_parameter (a_name)
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
