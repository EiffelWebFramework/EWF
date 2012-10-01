note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	WSF_FILTER_URI_TEMPLATE_HANDLER

inherit
	WSF_FILTER_HANDLER
		redefine
			next
		end

	WSF_URI_TEMPLATE_HANDLER

feature -- Access

	next: detachable WSF_FILTER_URI_TEMPLATE_HANDLER
			-- Next handler

feature -- Execution

	execute_next (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if attached next as n then
				n.execute (req, res)
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
