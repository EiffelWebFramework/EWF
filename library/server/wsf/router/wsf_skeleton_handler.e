note

	description: "[
						Policy-driven handlers.
						Implementers only need to concentrate on creating content.
						]"
	date: "$Date$"
	revision: "$Revision$"

deferred class WSF_SKELETON_HANDLER

inherit

	WSF_URI_TEMPLATE_ROUTING_HANDLER
		redefine
			execute
		end

	WSF_OPTIONS_POLICY

	WSF_PREVIOUS_POLICY

	WSF_METHOD_HELPER_FACTORY

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			check
				known_method: True -- Can't be done until WSF_METHOD_NOT_ALLOWED_RESPONSE
				-- is refactored.
				-- Then maybe this can become a precondition. But we will still (?)
				-- need a check that it isn't CONNECT or TRACE (it MIGHT be HEAD).
			end
			if req.is_request_method ({HTTP_REQUEST_METHODS}.method_options) then
				execute_options (req, res, router)
			else
				if attached new_method_helper (req.request_method) as l_helper then
					execute_method (req, res, l_helper)
				else
					handle_internal_server_error (res)
				end
			end
		end

	execute_method (req: WSF_REQUEST; res: WSF_RESPONSE; a_helper: WSF_METHOD_HELPER)
			-- Write response to `req' into `res', using `a_helper' as a logic helper.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_helper_attached: a_helper /= Void
		do
			check_resource_exists (req, a_helper)
			if a_helper.resource_exists then
				a_helper.execute_existing_resource (req, res, Current)
			else
				if attached req.http_if_match as l_if_match and then l_if_match.same_string ("*") then
					a_helper.handle_precondition_failed (req, res)
				else
					a_helper.execute_new_resource (req, res, Current)
				end
			end
		end

	check_resource_exists (req: WSF_REQUEST; a_helper: WSF_METHOD_HELPER)
			-- Call `a_helper.set_resource_exists' to indicate that `req.path_translated'
			--  is the name of an existing resource.
			-- Optionally, also call `req.set_server_data', if this is now available as a by-product
			--  of the existence check.
		require
			req_attached: req /= Void
			a_helper_attached: a_helper /= Void
		deferred
		end

	handle_internal_server_error (res: WSF_RESPONSE)
			-- Write "Internal Server Error" response to `res'.
		require
			res_attached: res /= Void
		local
			h: HTTP_HEADER
			m: STRING_8
		do
			create h.make
			h.put_content_type_text_plain
			m := "Server failed to handle request properly"
			h.put_content_length (m.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.internal_server_error)
			res.put_string (m)
		ensure
			response_status_is_set: res.status_is_set
			status_is_service_unavailable: res.status_code = {HTTP_STATUS_CODE}.internal_server_error
			body_sent: res.message_committed and then res.transfered_content_length > 0
		end
	
end
