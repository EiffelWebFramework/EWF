note
	description: "Summary description for {EWF_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ROUTER

inherit
	ITERABLE [TUPLE [mapping: WSF_ROUTER_MAPPING; request_methods: detachable WSF_ROUTER_METHODS]]

create
	make,
	make_with_base_url

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			create mappings.make (n)
			initialize
		end

	make_with_base_url (n: INTEGER; a_base_url: like base_url)
			-- Make router allocated for at least `n' maps,
			-- and use `a_base_url' as base_url
		do
			make (n)
			set_base_url (a_base_url)
		end

	initialize
			-- Initialize router
		do
			create mappings.make (10)
			create pre_execution_actions
		end

	mappings: ARRAYED_LIST [TUPLE [mapping: WSF_ROUTER_MAPPING; request_methods: detachable WSF_ROUTER_METHODS]]
			-- Existing mappings

feature -- Mapping

	map (a_mapping: WSF_ROUTER_MAPPING)
			-- Map `a_mapping'
		do
			map_with_request_methods (a_mapping, Void)
		end

	map_with_request_methods (a_mapping: WSF_ROUTER_MAPPING; rqst_methods: detachable WSF_ROUTER_METHODS)
			-- Map `a_mapping' for request methods `rqst_methods'
		do
			mappings.extend ([a_mapping, rqst_methods])
			a_mapping.handler.on_mapped (a_mapping, rqst_methods)
		end

feature -- Access

	is_dispatched: BOOLEAN
			-- `dispatch' set `is_dispatched' to True
			-- if handler was found and executed

	dispatch (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if attached dispatch_and_return_handler (req, res) then
				check is_dispatched: is_dispatched end
			end
		end

	dispatch_and_return_handler (req: WSF_REQUEST; res: WSF_RESPONSE): detachable WSF_HANDLER
		local
			l_req_method: READABLE_STRING_8
			m: WSF_ROUTER_MAPPING
		do
			is_dispatched := False
			l_req_method := request_method (req)

			across
				mappings as c
			until
				Result /= Void
			loop
				if attached c.item as l_info then
					if is_matching_request_methods (l_req_method, l_info.request_methods) then
						m := l_info.mapping
						if attached m.routed_handler (req, res, Current) as r then
							is_dispatched := True
							Result := r
						end
					end
				end
			end
		end

feature -- Hook

	execute_before (a_mapping: WSF_ROUTER_MAPPING)
		do
			pre_execution_actions.call ([a_mapping])
		end

	execute_after (a_mapping: WSF_ROUTER_MAPPING)
		do
		end

	pre_execution_actions: ACTION_SEQUENCE [TUPLE [WSF_ROUTER_MAPPING]]
			-- Action triggered before a route is execute
			--| Could be used for tracing, logging		

feature -- Base url

	count: INTEGER
		do
			Result := mappings.count
		end

	base_url: detachable READABLE_STRING_8
			-- Common start of any route url

feature -- Element change

	set_base_url (a_base_url: like base_url)
			-- Set `base_url' to `a_base_url'
			-- make sure no map is already added (i.e: count = 0)
		require
			a_valid_base_url: (a_base_url /= Void and then a_base_url.is_empty) implies (a_base_url.starts_with ("/") and not a_base_url.ends_with ("/"))
			no_handler_set: count = 0
		do
			if a_base_url = Void or else a_base_url.is_empty then
				base_url := Void
			else
				base_url := a_base_url
			end
		end

feature -- Traversing

	new_cursor: ITERATION_CURSOR [TUPLE [mapping: WSF_ROUTER_MAPPING; request_methods: detachable WSF_ROUTER_METHODS]]
			-- Fresh cursor associated with current structure
		do
			Result := mappings.new_cursor
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

	methods_head_get_post: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result.make (3)
			Result.enable_head
			Result.enable_get
			Result.enable_post
			Result.lock
		end

	methods_head_get: WSF_ROUTER_METHODS
		once ("THREAD")
			create Result.make (2)
			Result.enable_head
			Result.enable_get
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

end
