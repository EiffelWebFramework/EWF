note
	description: "[
					Default router based on URI Template map
				]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_TEMPLATE_ROUTER

inherit
	WSF_URI_TEMPLATE_ROUTER_I [WSF_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT], WSF_URI_TEMPLATE_HANDLER_CONTEXT]
		redefine
			map_agent_with_request_methods,
			map_agent_response_with_request_methods
		end

create
	make,
	make_with_base_url

feature -- Mapping agent

	map_agent_with_request_methods (a_id: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE]];
			 rqst_methods: detachable WSF_ROUTER_METHODS)
		local
			h: WSF_AGENT_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT]
		do
			create h.make (a_action)
			map_with_request_methods (a_id, h, rqst_methods)
		end

	map_agent_response_with_request_methods (a_id: READABLE_STRING_8; a_action: FUNCTION [ANY, TUPLE [ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST], WSF_RESPONSE_MESSAGE];
			 rqst_methods: detachable WSF_ROUTER_METHODS)
		local
			h: WSF_AGENT_RESPONSE_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT]
		do
			create h.make (a_action)
			map_with_request_methods (a_id, h, rqst_methods)
		end

note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
