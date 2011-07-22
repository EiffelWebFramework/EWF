note
	description: "Summary description for {URI_TEMPLATE_MATCH_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	URI_TEMPLATE_MATCH_RESULT

create
	make

feature {NONE} -- Initialization

	make (p: like path_variables; q: like query_variables)
		do
			path_variables := p
			query_variables := q
		end

feature -- Access

	path_variables: HASH_TABLE [STRING, STRING]
	query_variables: HASH_TABLE [STRING, STRING]

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

