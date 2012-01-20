note
	description: "Summary description for {REST_REQUEST_URI_TEMPLATE_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_REQUEST_URI_TEMPLATE_ROUTER_I [H -> REST_REQUEST_HANDLER [C], C -> REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT create make end]

inherit
	REQUEST_URI_TEMPLATE_ROUTER_I [H, C]

	REST_REQUEST_ROUTER [H, C]

create
	make,
	make_with_base_url

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
