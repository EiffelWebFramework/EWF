note
	description: "Summary description for WSF_AGENT_HANDLER."
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_AGENT_HANDLER [C -> WSF_HANDLER_CONTEXT]

inherit
	WSF_HANDLER [C]

create
	make

feature -- Initialization

	make (act: like action)
		do
			action := act
		end

feature -- Access

	action: PROCEDURE [ANY, TUPLE [ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE]]

feature -- Execution

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			action.call ([ctx, req, res])
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
