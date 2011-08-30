note
	description: "Summary description for {WGI_APPLICATION}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_APPLICATION

feature {NONE} -- Execution

	execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute the request
			-- See `req.input' for input stream
			--     `req.environment' for the Gateway environment	
			-- and `res' for the output buffer
		require
			res_status_unset: not res.status_is_set
		deferred
		ensure
			res_status_set: res.status_is_set
			res_committed: res.message_committed
		end

note
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
