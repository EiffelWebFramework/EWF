note
	description: "Summary description for {DEFAULT_REST_REQUEST_URI_TEMPLATE_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_REQUEST_URI_TEMPLATE_ROUTER

inherit
	REST_REQUEST_URI_TEMPLATE_ROUTER_I [REST_REQUEST_HANDLER [REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT], REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT]
		redefine
			map_agent_with_request_methods
		end

create
	make,
	make_with_base_url

feature -- Mapping

	map_agent_with_request_methods (a_id: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE]];
			 rqst_methods: detachable WSF_ROUTER_METHODS)
		local
			h: REST_REQUEST_AGENT_HANDLER [REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT]
		do
			create h.make (a_action)
			map_with_request_methods (a_id, h, rqst_methods)
		end

note
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
