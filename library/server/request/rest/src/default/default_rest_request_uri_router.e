note
	description: "Summary description for {DEFAULT_REST_REQUEST_URI_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_REST_REQUEST_URI_ROUTER

inherit
	REST_REQUEST_URI_ROUTER [REST_REQUEST_HANDLER [REST_REQUEST_URI_HANDLER_CONTEXT], REST_REQUEST_URI_HANDLER_CONTEXT]
		redefine
			map_agent_with_request_methods
		end

create
	make

feature -- Mapping

	map_agent_with_request_methods (a_id: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: REST_REQUEST_URI_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER]];
			 rqst_methods: detachable ARRAY [READABLE_STRING_8])
		local
			h: REST_REQUEST_AGENT_HANDLER [REST_REQUEST_URI_HANDLER_CONTEXT]
		do
			create h.make (a_action)
			map_with_request_methods (a_id, h, rqst_methods)
		end

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
