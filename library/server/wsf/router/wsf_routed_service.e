note
	description: "Summary description for {WSF_ROUTED_SERVICE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_ROUTED_SERVICE

feature -- Initialization

	initialize_router
			-- Initialize router
		do
			create_router
			setup_router
		end

	create_router
			-- Create `router'	
			--| could be redefine to initialize with proper capacity
		do
			create router.make (10)
		ensure
			router_created: router /= Void
		end

	setup_router
			-- Setup `router'
		require
			router_created: router /= Void
		deferred
		end

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- If the service is available, and request URI is not too long, dispatch the request
			-- and if handler is not found, execute the default procedure `execute_default'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
		do
			--| When we reach here, the request has already passed check for 400 (Bad request),
			--|  which is implemented in WSF_REQUEST.make_from_wgi (when it calls `analyze').
			if unavailable then
				handle_unavailable (res)
			elseif maximum_uri_length > 0 and then req.request_uri.count.to_natural_32 > maximum_uri_length then
				handle_request_uri_too_long (res)
			elseif attached router.dispatch_and_return_handler (req, res) as p then
				-- executed
			else
				execute_default (req, res)
			end
		end

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Dispatch requests without a matching handler.
		require
			req_attached: req /= Void
			res_attached: res /= Void
		local
			msg: WSF_DEFAULT_ROUTER_RESPONSE
		do
			--| TODO: update this to distinguish between 501, 403 and 404 results.
			create msg.make_with_router (req, router)
			msg.set_documentation_included (True)
			res.send (msg)
		end

feature -- Access

	router: WSF_ROUTER
			-- Router used to dispatch the request according to the WSF_REQUEST object
			-- and associated request methods

feature -- Measurement

	maximum_uri_length: NATURAL
			-- Maximum length in characters (or zero for no limit) permitted
			-- for {WSF_REQUEST}.request_uri

feature -- Status report

	unavailable: BOOLEAN
			-- Is service currently unavailable?

	unavailablity_message: detachable READABLE_STRING_8
			-- Message to be included as text of response body for {HTTP_STATUS_CODE}.service_unavailable

	unavailability_duration: NATURAL
			-- Delta seconds for service unavailability (0 if not known)

	unavailable_until: detachable DATE_TIME
			-- Time at which service becomes availabile again (if known)

feature -- Status setting

	set_available
			-- Set `unavailable' to `False'.
		do
			unavailable := False
			unavailablity_message := Void
			unavailable_until := Void
		ensure
			available: unavailable = False
			unavailablity_message_detached: unavailablity_message = Void
			unavailable_until_detached: unavailable_until = Void
		end

	set_unavailable (a_message: READABLE_STRING_8; a_duration: NATURAL; a_until: detachable DATE_TIME)
			-- Set `unavailable' to `True'.
		require
			a_message_attached: a_message /= Void
			a_duration_xor_a_until: a_duration > 0 implies a_until = Void
		do
			unavailable := True
			unavailablity_message := a_message
			unavailability_duration := a_duration
		ensure
			unavailable: unavailable = True
			unavailablity_message_aliased: unavailablity_message = a_message
			unavailability_duration_set: unavailability_duration = a_duration
			unavailable_until_aliased: unavailable_until = a_until
		end

	set_maximum_uri_length (a_len: NATURAL)
			-- Set `maximum_uri_length' to `a_len'.
			-- Can pass zero to mean no restrictions.
		do
			maximum_uri_length := a_len
		ensure
			maximum_uri_length_set: maximum_uri_length = a_len
		end

feature {NONE} -- Implementation

	handle_unavailable (res: WSF_RESPONSE)
			-- Write "Service unavailable" response to `res'.
		require
			unavailable: unavailable = True
			res_attached: res /= Void
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_plain
			check attached {READABLE_STRING_8} unavailablity_message as m then
					-- invariant
				h.put_content_length (m.count)
				h.put_current_date
				res.set_status_code ({HTTP_STATUS_CODE}.service_unavailable)
				if unavailability_duration > 0 then
					h.put_header_key_value ({HTTP_HEADER_NAMES}.header_retry_after, unavailability_duration.out)
				elseif unavailable_until /= Void then
					check attached {DATE_TIME} unavailable_until as u then
							-- $£#$%#! compiler!
						h.put_header_key_value ({HTTP_HEADER_NAMES}.header_retry_after,
							h.date_to_rfc1123_http_date_format (u))
					end
				end
				res.put_header_text (h.string)
				res.put_string (m)
			end
		end

	handle_request_uri_too_long (res: WSF_RESPONSE)
			-- Write "Request URI too long" response to `res'.
		require
			res_attached: res /= Void
		local
			h: HTTP_HEADER
			m: READABLE_STRING_8
		do
			create h.make
			h.put_content_type_text_plain		
			h.put_current_date
			m := "Maximum permitted length for request URI is " + maximum_uri_length.out + " characters"
			h.put_content_length (m.count)
			res.set_status_code ({HTTP_STATUS_CODE}.request_uri_too_long)
			res.put_header_text (h.string)
			res.put_string (m)
		end

invariant

	unavailblity_message_attached: unavailable implies unavailablity_message /= Void
	unavailablity_duration_xor_unavailable_until: unavailability_duration > 0 implies unavailable_until = Void

;note
	copyright: "2011-2013, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
