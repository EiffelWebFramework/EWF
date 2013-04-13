note

	description: "[
						Policy-driven helpers to implement a method.
						]"
	date: "$Date$"
	revision: "$Revision$"

deferred class WSF_METHOD_HELPER

feature -- Access

	resource_exists: BOOLEAN
			-- Does the requested resource (request URI) exist?

feature -- Setting

	set_resource_exists
			-- Set `resource_exists' to `True'.
		do
			resource_exists := True
		ensure
			set: resource_exists
		end

feature -- Basic operations

	execute_new_resource (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER)
			-- Write response to non-existing resource requested by  `req.' into `res'.
			-- Policy routines are available in `a_handler'.
			-- This default implementation does not apply for PUT requests.
			-- The behaviour for POST requests depends upon a policy.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_handler_attached: a_handler /= Void
		do
			if a_handler.resource_previously_existed (req) then
				--| TODO - should we be passing the entire request, or should we further
				--| simplify the programmer's task by passing `req.path_translated'?
				if a_handler.resource_moved_permanently (req) then
					-- TODO 301 Moved Permanently
				elseif a_handler.resource_moved_temporarily (req) then
					-- TODO 302 Found
				else
					-- TODO 410 Gone
				end
			else
				-- TODO 404 Not Found
			end
		end
	
	execute_existing_resource  (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER)
			-- Write response to existing resource requested by  `req.' into `res'.
			-- Policy routines are available in `a_handler'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_handler_attached: a_handler /= Void
			not_if_match_star: attached req.http_if_match as l_if_match implies not l_if_match.same_string ("*")
		local
			l_etags: LIST [READABLE_STRING_32]
		do
			if attached req.http_if_match as l_if_match then
				l_etags := l_if_match.split (',')
				
			else
				-- TODO: check_if_unmodified_since (req, res, a_handler)
			end
		end
	
	handle_precondition_failed  (req: WSF_REQUEST; res: WSF_RESPONSE)
			--
		require
			req_attached: req /= Void
			res_attached: res /= Void
		do
		end
	
end
