note
	description: "Summary description for {WSF_ROUTING_HANDLER }."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_TEMPLATE_ROUTING_HANDLER_I [H -> WSF_HANDLER [C],
							 C -> WSF_URI_TEMPLATE_HANDLER_CONTEXT create make end]

inherit
	WSF_ROUTING_HANDLER  [H, C]

create
	make,
	make_with_base_url

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			create router.make (n)
		end

	make_with_base_url (n: INTEGER; a_base_url: like base_url)
			-- Make allocated for at least `n' maps,
			-- and use `a_base_url' as base_url
		do
			create router.make_with_base_url (n, a_base_url)
		end

feature {NONE} -- Routing

	router: WSF_URI_TEMPLATE_ROUTER_I [H, C]

;note
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
