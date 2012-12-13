note
	description: "Summary description for {WSF_URI_TEMPLATE_MAPPING_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_TEMPLATE_MAPPING_I

inherit
	WSF_ROUTER_MAPPING

	WSF_SELF_DOCUMENTED_ROUTER_MAPPING

feature {NONE} -- Initialization

	make (s: READABLE_STRING_8; h: like handler)
		do
			make_from_template (create {URI_TEMPLATE}.make (s), h)
		end

	make_from_template (tpl: URI_TEMPLATE; h: like handler)
		do
			template := tpl
			set_handler (h)
		end

feature -- Access		

	associated_resource: READABLE_STRING_8
			-- Associated resource
		do
			Result := template.template
		end

	template: URI_TEMPLATE

feature -- Change

	set_handler (h: like handler)
		deferred
		end

feature -- Documentation

	description: STRING_32 = "Match-URI-Template"

feature -- Status

	is_mapping (req: WSF_REQUEST; a_router: WSF_ROUTER): BOOLEAN
			-- <Precursor>
		local
			tpl: URI_TEMPLATE
			p: READABLE_STRING_32
		do
			p := path_from_request (req)
			tpl := based_uri_template (template, a_router)
			Result := tpl.match (p) /= Void
		end

	routed_handler (req: WSF_REQUEST; res: WSF_RESPONSE; a_router: WSF_ROUTER): detachable WSF_HANDLER
		local
			tpl: URI_TEMPLATE
			p: READABLE_STRING_32
			new_src: detachable WSF_REQUEST_PATH_PARAMETERS_PROVIDER
		do
			p := path_from_request (req)
			tpl := based_uri_template (template, a_router)
			if attached tpl.match (p) as tpl_res then
				Result := handler
				a_router.execute_before (Current)
				--| Applied the context to the request
				--| in practice, this will fill the {WSF_REQUEST}.path_parameters
				create new_src.make (tpl_res.path_variables.count, tpl_res.path_variables)
				new_src.apply (req)
				execute_handler (handler, req, res)
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

feature {NONE} -- Execution

	execute_handler (h: like handler; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute handler `h' with `req' and `res' for Current mapping
		deferred
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
