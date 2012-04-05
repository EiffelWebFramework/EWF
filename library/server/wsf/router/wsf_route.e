note
	description: "[
					a WSF_ROUTE object associates a handler and the associated context at runtime
				]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ROUTE [H -> WSF_HANDLER [C], C -> WSF_HANDLER_CONTEXT]

create
	make

feature {NONE} -- Initialization

	make (h: H; c: C)
			-- Instantiate Current with `h' and `c'
		do
			handler := h
			context := c
		end

feature -- Access

	handler: H
			-- Handler

	context: C
			-- Context associated to `handler' for execution

invariant
	handler /= Void
	context /= Void

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
