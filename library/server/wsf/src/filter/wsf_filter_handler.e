note
	description: "[
				Handler that can also play the role of a filter, i.e. 
				than can pre-process incoming data and post-process outgoing data.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_FILTER_HANDLER [C -> WSF_HANDLER_CONTEXT]

inherit
	WSF_HANDLER [C]

feature -- Access

	next: detachable WSF_FILTER_HANDLER [C]
			-- Next filter

feature -- Element change

	set_next (a_next: WSF_FILTER_HANDLER [C])
			-- Set `next' to `a_next'
		do
			next := a_next
		ensure
			next_set: next = a_next
		end

feature {NONE} -- Implementation

	execute_next (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the `next' filter.
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
