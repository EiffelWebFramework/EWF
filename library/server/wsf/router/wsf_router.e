note
	description: "[
				URL dispatcher/router based on deferred mapping (to be defined in descendant)
				The associated context {WSF_HANDLER_CONTEXT} does contains information related to the matching at runtime.
			]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_ROUTER [H -> WSF_HANDLER [C], C -> WSF_HANDLER_CONTEXT]

inherit
	ITERABLE [TUPLE [handler: H; resource: READABLE_STRING_8; request_methods: detachable WSF_ROUTER_METHODS]]

feature {NONE} -- Initialization

	initialize
			-- Initialize router
		do
			create pre_route_execution_actions
		end

feature -- Status report

	has_map (a_resource: READABLE_STRING_8; rqst_methods: detachable WSF_ROUTER_METHODS; a_handler: detachable H): BOOLEAN
			-- Has a map corresponding to `a_resource' and `rqst_methods' other than `a_handler'?
		do
			if attached handlers_matching_map (a_resource, rqst_methods) as lst then
				Result := a_handler = Void or else not lst.has (a_handler)
			end
		end

	handlers_matching_map (a_resource: READABLE_STRING_8; rqst_methods: detachable WSF_ROUTER_METHODS): detachable LIST [H]
			-- Existing handlers matching map with `a_resource' and `rqst_methods'
		deferred
		end

feature -- Mapping

	map (a_resource: READABLE_STRING_8; h: H)
			-- Map handler `h' with `a_resource'
		require
			has_not_such_map: not has_map (a_resource, Void, h)
		do
			map_with_request_methods (a_resource, h, Void)
		end

	map_routing (a_resource: READABLE_STRING_8; h: H)
			-- Map handler `h' with `a_resource'
		require
			has_not_such_map: not has_map (a_resource, Void, h)
		do
			map (a_resource, h)
		end

	map_with_request_methods (a_resource: READABLE_STRING_8; h: H; rqst_methods: detachable WSF_ROUTER_METHODS)
			-- Map handler `h' with `a_resource' and `rqst_methods'
		require
			has_not_such_map: not has_map (a_resource, rqst_methods, h)
		deferred
		end

feature -- Mapping agent		

	map_agent (a_resource: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE]])
			-- Map `a_action' as an handler with `a_resource'
		do
			map_agent_with_request_methods (a_resource, a_action, Void)
		end

	map_agent_with_request_methods (a_resource: READABLE_STRING_8; a_action: PROCEDURE [ANY, TUPLE [ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE]];
			 rqst_methods: detachable WSF_ROUTER_METHODS)
			-- Map `a_action' as an handler with `a_resource' and `rqst_methods'			
		local
			rah: WSF_AGENT_HANDLER [C]
		do
			create rah.make (a_action)
			if attached {H} rah as h then
				map_with_request_methods (a_resource, h, rqst_methods)
			else
				check valid_agent_handler: False end
			end
		end

feature -- Mapping response agent		

	map_agent_response (a_resource: READABLE_STRING_8; a_function: FUNCTION [ANY, TUPLE [ctx: C; req: WSF_REQUEST], WSF_RESPONSE_MESSAGE])
			-- Map response as Result `a_function' as an handler with `a_resource'	
		do
			map_agent_response_with_request_methods (a_resource, a_function, Void)
		end

	map_agent_response_with_request_methods (a_resource: READABLE_STRING_8; a_function: FUNCTION [ANY, TUPLE [ctx: C; req: WSF_REQUEST], WSF_RESPONSE_MESSAGE];
			 rqst_methods: detachable WSF_ROUTER_METHODS)
			-- Map response as Result `a_function' as an handler with `a_resource' and `rqst_methods'			
		local
			rah: WSF_AGENT_RESPONSE_HANDLER [C]
		do
			create rah.make (a_function)
			if attached {H} rah as h then
				map_with_request_methods (a_resource, h, rqst_methods)
			else
				check valid_agent_handler: False end
			end
		end

feature -- Base url

	base_url: detachable READABLE_STRING_8
			-- Common start of any route url

feature -- Element change

	set_base_url (a_base_url: like base_url)
			-- Set `base_url' to `a_base_url'
			-- make sure no map is already added (i.e: count = 0)
		require
			no_handler_set: count = 0
		do
			if a_base_url = Void or else a_base_url.is_empty then
				base_url := Void
			else
				base_url := a_base_url
			end
		end

feature -- Hook

	pre_route_execution_actions: ACTION_SEQUENCE [TUPLE [like route]]
			-- Action triggered before a route is execute
			--| Could be used for tracing, logging

feature -- Routing

	route (req: WSF_REQUEST): detachable WSF_ROUTE [H, C]
			-- Route matching `req'.
		do
			Result := matching_route (req)
		end

feature -- Execution

	execute_route (a_route: WSF_ROUTE [H,C]; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Process route `a_route'
		require
			a_route_attached: a_route /= Void
		local
			ctx: C
		do
			pre_route_execution_actions.call ([a_route])
			ctx := a_route.context
			ctx.apply (req)
			a_route.handler.execute (ctx, req, res)
			ctx.revert (req)
		rescue
			a_route.context.revert (req)
		end

	dispatch (req: WSF_REQUEST; res: WSF_RESPONSE): BOOLEAN
			-- Dispatch `req, res' to the associated handler
			-- And return True is handled, otherwise False
		do
			if attached route (req) as r then
				Result := True
				execute_route (r, req, res)
			end
		end

	dispatch_and_return_handler (req: WSF_REQUEST; res: WSF_RESPONSE): detachable H
			-- Dispatch `req, res' to the associated handler
			-- And return this handler
			-- If Result is Void, this means no handler was found.
		do
			if attached route (req) as r then
				Result := r.handler
				execute_route (r, req, res)
			end
		end

feature {WSF_ROUTED_SERVICE_I} -- Implementation

	default_handler_context (req: WSF_REQUEST): C
			-- Default handler context associated with `req'.
			--| It can be used to build a context if needed.
		deferred
		end

feature -- status report

	count: INTEGER
			-- Count of maps handled by current	
		do
			across
				Current as curs
			loop
				if attached {WSF_ROUTING_HANDLER  [H, C]} curs.item.handler as rh then
					Result := Result + rh.count + 1 --| +1 for the handler itself
				else
					Result := Result + 1
				end
			end
		end

feature -- Traversing

	new_cursor: ITERATION_CURSOR [TUPLE [handler: H; resource: READABLE_STRING_8; request_methods: detachable WSF_ROUTER_METHODS]]
			-- Fresh cursor associated with current structure
		deferred
		end

feature {WSF_ROUTED_SERVICE_I} -- Handler

	source_uri (req: WSF_REQUEST): READABLE_STRING_32
			-- URI to use to find handler.
		do
			Result := req.path_info
		end

	matching_route (req: WSF_REQUEST): detachable WSF_ROUTE [H, C]
			-- Handler whose map matched with `req' with associated Context
		require
			req_valid: source_uri (req) /= Void
		deferred
		ensure
			source_uri_unchanged: source_uri (req).same_string (old source_uri (req))
		end

feature -- Request methods helper

	methods_head: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result
			Result.enable_head
			Result.lock
		end

	methods_options: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result
			Result.enable_options
			Result.lock
		end

	methods_get: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result
			Result.enable_get
			Result.lock
		end

	methods_post: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result
			Result.enable_post
			Result.lock
		end

	methods_put: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result
			Result.enable_put
			Result.lock
		end

	methods_delete: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result
			Result.enable_delete
			Result.lock
		end

	methods_get_post: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result.make (2)
			Result.enable_get
			Result.enable_post
			Result.lock
		end

	methods_put_post: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result.make (2)
			Result.enable_put
			Result.enable_post
			Result.lock
		end

feature {NONE} -- Access: Implementation

	request_method (req: WSF_REQUEST): READABLE_STRING_8
			-- Request method from `req' to be used in the router implementation.
		local
			m: READABLE_STRING_8
		do
			m := req.request_method
			if m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_get) then
				Result := {HTTP_REQUEST_METHODS}.method_get
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_post) then
				Result := {HTTP_REQUEST_METHODS}.method_post
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_head) then
				Result := {HTTP_REQUEST_METHODS}.method_head
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_trace) then
				Result := {HTTP_REQUEST_METHODS}.method_trace
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_options) then
				Result := {HTTP_REQUEST_METHODS}.method_options
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_put) then
				Result := {HTTP_REQUEST_METHODS}.method_put
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_delete) then
				Result := {HTTP_REQUEST_METHODS}.method_delete
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_connect) then
				Result := {HTTP_REQUEST_METHODS}.method_connect
			elseif m.is_case_insensitive_equal ({HTTP_REQUEST_METHODS}.method_patch) then
				Result := {HTTP_REQUEST_METHODS}.method_patch
			else
				Result := m.as_upper
			end
		end

	is_matching_request_methods (a_request_method: READABLE_STRING_8; a_rqst_methods: detachable WSF_ROUTER_METHODS): BOOLEAN
			-- `a_request_method' is matching `a_rqst_methods' contents
		do
			if a_rqst_methods /= Void and then not a_rqst_methods.is_empty then
				Result := a_rqst_methods.has (a_request_method)
			else
				Result := True
			end
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
