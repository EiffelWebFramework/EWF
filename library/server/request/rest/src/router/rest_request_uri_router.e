note
	description: "Summary description for {REST_REQUEST_URI_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_REQUEST_URI_ROUTER [H -> REST_REQUEST_HANDLER [C], C -> REST_REQUEST_URI_HANDLER_CONTEXT create make end]

inherit
	REQUEST_URI_ROUTER [H, C]

	REST_REQUEST_ROUTER [H, C]


create
	make

feature -- Mapping

--	map_agent_with_request_methods (a_id: READABLE_STRING_8; a_action: like {REST_REQUEST_AGENT_HANDLER}.action; rqst_methods: detachable ARRAY [READABLE_STRING_8])
--		do
--			Precursor (a_id, a_action, rqst_methods)
--		end

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
