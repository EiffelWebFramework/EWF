note

	description: "[
                  Policy-driven HTTP/1.1 compliant servers.

                  Users create a web server by inheriting from this class,
                  providing implementations for deferred policy routines
                  (usually by inheriting from canned policy classes),
                  and configuring the router.
                ]"

	documentation: "TODO"
	date: "$Date$"
	revision: "$Revision$"

deferred class WSF_SKELETON_SERVER

inherit

	WSF_URI_TEMPLATE_ROUTED_SERVICE
		redefine
			execute
		end

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


feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- If the service is available, dispatch the request
			-- and if handler is not found, execute the default procedure `execute_default'.
		do
			if unavailable then
				handle_unavailable (res)
			elseif attached router.dispatch_and_return_handler (req, res) as p then
				-- executed
			else
				execute_default (req, res)
			end
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

invariant

	unavailblity_message_attached: unavailable implies unavailablity_message /= Void
	unavailablity_duration_xor_unavailable_until: unavailability_duration > 0 implies unavailable_until = Void

note
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
