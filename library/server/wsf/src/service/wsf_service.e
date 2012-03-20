note
	description: "[
		Inherit from this class to implement the main entry of your web service
		You just need to implement `execute', get data from the request `req'
		and write the response in `res'
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_SERVICE

--inherit
--	WGI_SERVICE
--		rename
--			execute as wgi_execute
--		end

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the request
			-- See `req.input' for input stream
    		--     `req.meta_variables' for the CGI meta variable
			-- and `res' for output buffer
		deferred
		end

--feature {WGI_CONNECTOR} -- WGI Execution

--	wgi_execute (req: WGI_REQUEST; res: WGI_RESPONSE)
--		local
--			w_res: detachable WSF_RESPONSE
--			w_req: detachable WSF_REQUEST
--		do
--			create w_res.make_from_wgi (res)
--			create w_req.make_from_wgi (req)
--			execute (w_req, w_res)
--			w_req.destroy
--		rescue
--			if w_res /= Void then
--				w_res.flush
--			end
--			if w_req /= Void then
--				w_req.destroy
--			end
--		end

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
