note
	description: "[
				Request handler object which is called by a WSF_ROUTER
				A response handler should implement the method
				
					response (ctx: C; req: WSF_REQUEST): WSF_RESPONSE_MESSAGE

					
				The class is generic, this way one can use a custom WSF_HANDLER_CONTEXT if needed
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_RESPONSE_HANDLER [C -> WSF_HANDLER_CONTEXT]

inherit
	WSF_HANDLER [C]

feature -- Response

	response (ctx: C; req: WSF_REQUEST): WSF_RESPONSE_MESSAGE
		require
			is_valid_context: is_valid_context (req)
		deferred
		ensure
			Result_attached: Result /= Void
		end

feature -- Execution

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler	
		do
			res.send (response (ctx, req))
		end

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
