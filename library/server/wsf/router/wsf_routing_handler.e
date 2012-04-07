note
	description: "[
					WSF_ROUTING_HANDLER is mainly to group a set of handler having the same base
					such as /users for 
						/users/by/id/{id}
						/users/by/name/name}
					
					It can be used to optimize the router, where the router checks only the base path before checking each entries
					Then for 
						/a/a1
						/a/a2
						/a/a3
						/a/a4
						/b/b1
						/b/b2
						/b/b3
					2 routing handlers could be used "/a" and "/b"
					then to find the /b/b2 match, the router has to do only 
						/a /b /b/b1 and /b/b2 i.e: 4 checks
					instead of /a/a1 /a/a2 /a/a3 /a/a4 /b/b1 /b/b2: i.e: 6 checks
					On router with deep arborescence this could be significant
				]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_ROUTING_HANDLER  [H -> WSF_HANDLER [C],
							 C -> WSF_HANDLER_CONTEXT]

inherit
	WSF_HANDLER [C]

feature -- Access

	count: INTEGER
			-- Count of maps handled by current
		do
			Result := router.count
		end

	base_url: detachable READABLE_STRING_8
		do
			Result := router.base_url
		end

feature -- Element change

	set_base_url (a_base_url: like base_url)
			-- Set `base_url' to `a_base_url'
			-- make sure no map is already added (i.e: count = 0)
		require
			no_handler_set: count = 0
		do
			router.set_base_url (a_base_url)
		end

feature -- Execution

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		local
			r: detachable WSF_ROUTE [H, C]
		do
			r := router.route (req)
			if r = Void then
				res.put_header ({HTTP_STATUS_CODE}.not_found, <<[{HTTP_HEADER_NAMES}.header_content_length, "0"]>>)
			else
				router.execute_route (r, req, res)
			end
		end

feature {NONE} -- Routing

	router: WSF_ROUTER [H, C]
		deferred
		end

feature -- Mapping

	map (a_resource: READABLE_STRING_8; h: H)
			-- Map handler `h' with `a_resource'
		do
			router.map (a_resource, h)
		end

	map_with_request_methods (a_resource: READABLE_STRING_8; h: H; rqst_methods: detachable ARRAY [READABLE_STRING_8])
			-- Map handler `h' with `a_resource' and `rqst_methods'
		do
			router.map_with_request_methods (a_resource, h, rqst_methods)
		end

	map_agent (a_resource: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE]])
		do
			router.map_agent (a_resource, a_action)
		end

	map_agent_with_request_methods (a_resource: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE]];
			 rqst_methods: detachable ARRAY [READABLE_STRING_8])
		do
			router.map_agent_with_request_methods (a_resource, a_action, rqst_methods)
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
