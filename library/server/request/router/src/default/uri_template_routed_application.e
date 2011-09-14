note
	description: "Summary description for {DEFAULT_URI_TEMPLATE_ROUTED_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	URI_TEMPLATE_ROUTED_APPLICATION

inherit
	ROUTED_APPLICATION_I [REQUEST_HANDLER [REQUEST_URI_TEMPLATE_HANDLER_CONTEXT_I], REQUEST_URI_TEMPLATE_HANDLER_CONTEXT_I]
		redefine
			router
		end

feature -- Router

	router: REQUEST_URI_TEMPLATE_ROUTER

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
