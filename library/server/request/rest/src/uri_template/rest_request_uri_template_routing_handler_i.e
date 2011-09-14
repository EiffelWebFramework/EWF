note
	description: "Summary description for {REQUEST_ROUTING_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_REQUEST_URI_TEMPLATE_ROUTING_HANDLER_I [H -> REST_REQUEST_HANDLER [C],
							 C -> REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT create make end]

inherit
	REQUEST_URI_TEMPLATE_ROUTING_HANDLER_I [H, C]
		redefine
			router,
			execute
		end

	REST_REQUEST_HANDLER [C]
		undefine
			execute
		end

create
	make

feature -- Status report

	authentication_required (req: WGI_REQUEST): BOOLEAN
		do
			Result := internal_authentication_required
		end

feature {NONE} -- Implementation

	internal_authentication_required: BOOLEAN

feature -- Execution

	execute (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			Precursor {REST_REQUEST_HANDLER} (ctx, req, res)
		end

	execute_application (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			check should_not_occur: False end
		end

feature {NONE} -- Routing

	router: REST_REQUEST_URI_TEMPLATE_ROUTER_I [H, C]

;note
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
