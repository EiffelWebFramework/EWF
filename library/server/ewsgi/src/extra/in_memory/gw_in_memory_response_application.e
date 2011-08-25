note
	description: "Summary description for {GW_IN_MEMORY_RESPONSE_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_IN_MEMORY_RESPONSE_APPLICATION

inherit
	EWSGI_APPLICATION
		rename
			execute as app_execute
		end


feature -- Execution

	app_execute (req: EWSGI_REQUEST; res: EWSGI_RESPONSE_BUFFER)
			-- Execute the request
			-- See `req.input' for input stream
			--     `req.environment' for the Gateway environment	
			-- and `res' for output buffer
		do
			execute (req, new_response (req, res))
		end

feature -- Execute

	execute (req: EWSGI_REQUEST; res: EWSGI_RESPONSE_BUFFER)
			-- Execute the request
			-- See `req.input' for input stream
			--     `req.environment' for the Gateway environment	
			-- and `res' for output buffer
		require
			res_status_unset: not res.status_is_set
		deferred
		ensure
			res_status_set: res.status_is_set
		end

feature {NONE} -- Implementation	

	new_response (req: EWSGI_REQUEST; a_res: EWSGI_RESPONSE_BUFFER): GW_IN_MEMORY_RESPONSE
		do
			create {GW_IN_MEMORY_RESPONSE} Result.make (a_res)
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
