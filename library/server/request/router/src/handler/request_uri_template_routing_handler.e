note
	description: "Summary description for {REQUEST_ROUTING_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_TEMPLATE_ROUTING_HANDLER [H -> REQUEST_HANDLER [C],
							 C -> REQUEST_URI_TEMPLATE_HANDLER_CONTEXT create make end]

inherit
	REQUEST_ROUTING_HANDLER [H, C]

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			create router.make (n)
		end

feature {NONE} -- Routing

	router: REQUEST_URI_TEMPLATE_ROUTER [H, C]

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
