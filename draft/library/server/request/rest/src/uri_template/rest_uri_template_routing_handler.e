note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	REST_URI_TEMPLATE_ROUTING_HANDLER [C -> WSF_HANDLER_CONTEXT create make end]

inherit
	WSF_URI_TEMPLATE_ROUTING_CONTEXT_HANDLER [C]
		rename
			execute as old_execute,
			uri_template_execute as execute
		redefine
			execute
		end

	REST_REQUEST_HANDLER [C]
		undefine
			execute
		end

create
	make,
	make_with_router

feature -- Status report

	authentication_required (req: WSF_REQUEST): BOOLEAN
		do
			Result := internal_authentication_required
		end

feature {NONE} -- Implementation

	internal_authentication_required: BOOLEAN

feature -- Execution

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			pre_execute (ctx, req, res)
			Precursor {WSF_URI_TEMPLATE_ROUTING_CONTEXT_HANDLER} (ctx, req, res)
			post_execute (ctx, req, res)
		end

	execute_application (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			check should_not_occur: False end
		end


invariant
--	invariant_clause: True

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
