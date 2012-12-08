note
	description: "Summary description for {WSF_URI_TEMPLATE_CONTEXT_MAPPING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_TEMPLATE_CONTEXT_MAPPING [C -> WSF_HANDLER_CONTEXT create make end]

inherit
	WSF_ROUTER_CONTEXT_MAPPING [C]

	WSF_SELF_DOCUMENTED_ROUTER_MAPPING
		undefine
			debug_output
		end

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

	associated_resource: READABLE_STRING_8
			-- Associated resource
		do
			Result := template.template
		end

	handler: WSF_URI_TEMPLATE_CONTEXT_HANDLER [C]

	template: URI_TEMPLATE

feature -- Documentation

	description: STRING_32 = "Match-URI-Template"

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
			ctx: detachable C
			new_src: detachable WSF_REQUEST_PATH_PARAMETERS_PROVIDER
		do
			p := path_from_request (req)
			tpl := based_uri_template (template, a_router)
			if attached tpl.match (p) as tpl_res then
				Result := handler
				create ctx.make (req, Current)
				a_router.execute_before (Current)
				--| Applied the context to the request
				--| in practice, this will fill the {WSF_REQUEST}.path_parameters
				create new_src.make (tpl_res.path_variables.count, tpl_res.path_variables)
				new_src.apply (req)
				handler.execute (ctx, req, res)
				--| Revert {WSF_REQUEST}.path_parameters_source to former value
				--| In case the request object passed by other handler that alters its values.
				new_src.revert (req)
				a_router.execute_after (Current)
			end
		rescue
			if new_src /= Void then
				new_src.revert (req)
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
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
