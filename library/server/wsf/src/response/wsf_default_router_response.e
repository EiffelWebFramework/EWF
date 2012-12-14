note
	description: "Summary description for {WSF_DEFAULT_ROUTER_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DEFAULT_ROUTER_RESPONSE

inherit
	WSF_DEFAULT_RESPONSE
		redefine
			send_to
		end

create
	make_with_router

feature {NONE} -- Initialization

	make_with_router (req: WSF_REQUEST; a_router: like router)
			-- Initialize Current with request `req' and router `a_router'
			-- Initialize Current with request `req'
		do
			router := a_router
			make (req)
		end

feature -- Access

	router: WSF_ROUTER
			-- Associated router.

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
			-- Send Current message to `res'
			--
			-- This feature should be called via `{WSF_RESPONSE}.send (obj)'
			-- where `obj' is the current object
		local
			msg: WSF_RESPONSE_MESSAGE
			req: like request
			not_found: WSF_NOT_FOUND_RESPONSE
			not_allowed: WSF_METHOD_NOT_ALLOWED_RESPONSE
			trace: WSF_TRACE_RESPONSE
		do
			req := request
			if req.is_request_method ({HTTP_REQUEST_METHODS}.method_trace) then
				create trace.make (req)
				msg := trace
			elseif attached router.allowed_methods_for_request (req) as mtds and then not mtds.is_empty then
				create not_allowed.make (req)
				not_allowed.set_suggested_methods (mtds)
				msg := not_allowed
			else
				create not_found.make (req)

				msg := not_found
			end
			res.send (msg)
		end

end
