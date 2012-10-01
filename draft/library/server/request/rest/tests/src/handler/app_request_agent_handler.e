note
	description: "Summary description for REST_REQUEST_AGENT_HANDLER."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APP_REQUEST_AGENT_HANDLER

inherit
	APP_REQUEST_HANDLER
--		undefine
--			execute, pre_execute, post_execute
--		end

	REST_REQUEST_AGENT_HANDLER [APP_REQUEST_HANDLER_CONTEXT]
		undefine
			execute
--			authenticated
		end

create
	make

feature -- Access

	execute_application (ctx: APP_REQUEST_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute (ctx, req, res)
		end

	authentication_required (req: WSF_REQUEST): BOOLEAN
			-- Is authentication required
			-- might depend on the request environment
			-- or the associated resources
		do
			Result := False
		end


note
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
