note
	description: "Summary description for REST_REQUEST_AGENT_HANDLER."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_REQUEST_AGENT_HANDLER [C -> REST_REQUEST_HANDLER_CONTEXT]

inherit
	REQUEST_AGENT_HANDLER [C]
		redefine
			execute
		end

	REST_REQUEST_HANDLER [C]
		redefine
			execute
		end
create
	make

feature -- status

	authentication_required: BOOLEAN

feature -- Element change

	set_authentication_required (b: like authentication_required)
		do
			authentication_required := b
		end

feature -- Execution

	execute (a_hdl_context: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			Precursor {REST_REQUEST_HANDLER} (a_hdl_context, req, res)
		end

--	execute_application (ctx: REST_REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
--		do
--			action.call ([ctx, req, res])
--		end

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
