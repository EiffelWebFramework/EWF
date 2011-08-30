note
	description: "Summary description for {REQUEST_HANDLER_CONTEXT}."
	author: ""
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

	request: WGI_REQUEST
			-- Associated request

	path: STRING
			-- ???

	request_content_type (content_type_supported: detachable ARRAY [STRING]): detachable READABLE_STRING_8
		local
			s: detachable READABLE_STRING_32
			i,n: INTEGER
		do
			s := request.content_type
			if s /= Void then
				Result := s
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
						end
						l_accept_lst.forth
					end
				end
			end
		end

feature -- Query	

	path_parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
			-- Parameter value for path variable `a_name'
		deferred
		end

	query_parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
			-- Parameter value for query variable `a_name'	
			--| i.e after the ? character
		deferred
		end

	parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
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
