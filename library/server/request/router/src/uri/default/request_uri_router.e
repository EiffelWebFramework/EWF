note
	description: "Summary description for {DEFAULT_REQUEST_URI_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_ROUTER

inherit
	REQUEST_URI_ROUTER_I [REQUEST_HANDLER [REQUEST_URI_HANDLER_CONTEXT], REQUEST_URI_HANDLER_CONTEXT]
		redefine
			map_agent_with_request_methods
		end
create
	make

feature -- Mapping

	map_agent_with_request_methods (a_id: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: REQUEST_URI_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE]];
			 rqst_methods: detachable ARRAY [READABLE_STRING_8])
		local
			h: REQUEST_AGENT_HANDLER [REQUEST_URI_HANDLER_CONTEXT]
		do
			create h.make (a_action)
			map_with_request_methods (a_id, h, rqst_methods)
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
