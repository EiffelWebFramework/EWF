note
	description: "Summary description for {EWF_ROUTER_URI_TEMPLATE_WITH_CONTEXT_PATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_TEMPLATE_WITH_CONTEXT_MAPPING

inherit
	WSF_ROUTER_MAPPING

create
	make,
	make_from_template

feature {NONE} -- Initialization

	make (s: READABLE_STRING_8; h: like handler)
		do
			make_from_template (create {URI_TEMPLATE}.make (s), h)
		end

	make_from_template (tpl: URI_TEMPLATE; h: like handler)
		do
			template := tpl
			handler := h
		end

feature -- Access		

	handler: WSF_URI_TEMPLATE_WITH_CONTEXT_HANDLER

	template: URI_TEMPLATE

feature -- Element change

	set_handler	(h: like handler)
		do
			handler := h
		end

feature -- Status

	routed_handler (req: WSF_REQUEST; res: WSF_RESPONSE; a_router: WSF_ROUTER): detachable WSF_HANDLER
		local
			tpl: URI_TEMPLATE
			p: READABLE_STRING_32
			ctx: detachable WSF_URI_TEMPLATE_HANDLER_CONTEXT
		do
			p := path_from_request (req)
			tpl := based_uri_template (template, a_router)
			if attached tpl.match (p) as tpl_res then
				Result := handler
				create ctx.make (req, tpl, tpl_res, path_from_request (req))
				a_router.execute_before (Current)
				--| Applied the context to the request
				--| in practice, this will fill the {WSF_REQUEST}.path_parameters
				ctx.apply (req)
				handler.execute (ctx, req, res)
				--| Revert {WSF_REQUEST}.path_parameters_source to former value
				--| In case the request object passed by other handler that alters its values.
				ctx.revert (req)
				a_router.execute_after (Current)
			end
		rescue
			if ctx /= Void then
				ctx.revert (req)
			end
		end

feature {NONE} -- Implementation

	based_uri_template (a_tpl: like template; a_router: WSF_ROUTER): like template
		do
			if attached a_router.base_url as l_base_url then
				Result := a_tpl.duplicate
				Result.set_template (l_base_url + a_tpl.template)
			else
				Result := a_tpl
			end
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
