note
	description: "[
						WSF_URI_ROUTING_HANDLER is a default descendant of WSF_URI_ROUTING_HANDLER_I
						for WSF_URI_ROUTER
				]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_ROUTING_HANDLER

inherit
	WSF_URI_ROUTING_HANDLER_I [WSF_HANDLER [WSF_URI_HANDLER_CONTEXT], WSF_URI_HANDLER_CONTEXT]
		redefine
			router
		end

create
	make

feature {NONE} -- Routing

	router: WSF_URI_ROUTER

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
