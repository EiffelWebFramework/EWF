note
	description: "Summary description for {APP_REQUEST_ROUTING_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APP_REQUEST_ROUTING_HANDLER

inherit
	APP_REQUEST_HANDLER
		rename
			execute as uri_template_execute
		undefine
			uri_template_execute
		end

	WSF_URI_TEMPLATE_ROUTING_CONTEXT_HANDLER [APP_REQUEST_HANDLER_CONTEXT]

create
	make

feature -- Access

	authentication_required (req: WSF_REQUEST): BOOLEAN
			-- Is authentication required
			-- might depend on the request environment
			-- or the associated resources
		do
		end

feature -- Execution

	execute_application	 (ctx: APP_REQUEST_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			uri_template_execute (ctx, req, res)
		end

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
