note
	description: "Summary description for {EWSGI_RESPONSE_APPLICATION} "
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EWSGI_RESPONSE_APPLICATION

feature -- Execution

	execute (req: EWSGI_REQUEST; res: EWSGI_RESPONSE_BUFFER)
			-- Execute the request
			-- See `req.input' for input stream
			--     `req.environment' for the Gateway environment	
			-- and `res.output' for output stream
        local
            rs: EWSGI_RESPONSE
            s: STRING
        do
            rs := response (req)
            if rs.ready_to_transmit then
            	rs.transmit_to (res)
            else
                -- Report internal server error.
                -- Response not ready to transmit!
                -- Implementor of EWSGI_APPLICATION has not done his job!
                create rs.make
                rs.set_status (500)
                rs.set_header ("Content-Type", "text/plain")
                rs.set_message_body ("Incomplete server implementation: Response not ready to transmit.%NTell the programmer to finish his/her job!")
                rs.transmit_to (res)
            end
		end

feature -- Response		

    response (request: EWSGI_REQUEST): EWSGI_RESPONSE
            -- HTTP response for given 'request'.
        deferred
        ensure
            ready_to_transmit: Result.ready_to_transmit
        end

;note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
