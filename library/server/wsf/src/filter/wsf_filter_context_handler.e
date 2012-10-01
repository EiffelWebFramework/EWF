note
	description: "Summary description for {WSF_FILTER_CONTEXT_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_FILTER_CONTEXT_HANDLER

inherit
	WSF_FILTER_HANDLER
		redefine
			next
		end

	WSF_CONTEXT_HANDLER

feature -- Access

	next: detachable WSF_FILTER_CONTEXT_HANDLER
			-- Next handler

feature {WSF_ROUTER} -- Mapping

	new_mapping (a_resource: READABLE_STRING_8): WSF_ROUTER_CONTEXT_MAPPING
			-- New mapping built with Current as handler
		deferred
		end

feature {NONE} -- Implementation

	execute_next (ctx: WSF_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if attached next as n then
				n.execute (ctx, req, res)
			end
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
