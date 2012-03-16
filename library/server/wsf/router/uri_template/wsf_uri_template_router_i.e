note
	description: "Summary description for {WSF_URI_TEMPLATE_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_TEMPLATE_ROUTER_I [H -> WSF_HANDLER [C], C -> WSF_URI_TEMPLATE_HANDLER_CONTEXT create make end]

inherit
	WSF_ROUTER [H, C]

create
	make,
	make_with_base_url

feature -- Initialization

	make (n: INTEGER)
		do
			create handlers.make (n)
			create templates.make (n)
			handlers.compare_objects
		end

	make_with_base_url (n: INTEGER; a_base_url: like base_url)
			-- Make router allocated for at least `n' maps,
			-- and use `a_base_url' as base_url
		do
			make (n)
			set_base_url (a_base_url)
		end

feature -- Status report		

	handlers_matching_map (a_resource: READABLE_STRING_8; rqst_methods: detachable ARRAY [READABLE_STRING_8]): detachable LIST [H]
		local
			l_res: READABLE_STRING_8
		do
			l_res := based_resource (a_resource)
			across
				handlers as c
			loop
				if c.item.resource.same_string (l_res) then
					if
						rqst_methods = Void or else
						across rqst_methods as rq some is_matching_request_methods (rq.item, c.item.request_methods) end
					then
						if Result = Void then
							create {ARRAYED_LIST [H]} Result.make (1)
						end
						Result.extend (c.item.handler)
					end
				end
			end
		end

feature -- Registration

	map_with_uri_template (uri: URI_TEMPLATE; h: H)
		require
			has_not_such_map: not has_map (uri.template, Void, h)
		do
			map_with_uri_template_and_request_methods (uri, h, Void)
		end

	map_with_uri_template_and_request_methods (uri: URI_TEMPLATE; h: H; rqst_methods: detachable ARRAY [READABLE_STRING_8])
		require
			uri_is_valid: uri.is_valid
			has_not_such_map: not has_map (uri.template, rqst_methods, h)
		local
			l_tpl: like {URI_TEMPLATE}.template
			l_uri: URI_TEMPLATE
		do
			l_uri := based_uri (uri)
			l_tpl := l_uri.template

			handlers.force ([h, l_tpl, formatted_request_methods (rqst_methods)])
			templates.force (l_uri, l_tpl)
			h.on_handler_mapped (l_tpl, rqst_methods)
		end

	map_with_request_methods (tpl: READABLE_STRING_8; h: H; rqst_methods: detachable ARRAY [READABLE_STRING_8])
		do
			map_with_uri_template_and_request_methods (create {URI_TEMPLATE}.make (tpl), h, rqst_methods)
		end

feature {NONE} -- Implementation

	based_uri (uri: URI_TEMPLATE): URI_TEMPLATE
		do
			if attached base_url as l_base_url then
				Result := uri.duplicate
				Result.set_template (l_base_url + uri.template)
			else
				Result := uri
			end
		end

	based_resource (a_resource: READABLE_STRING_8): READABLE_STRING_8
		do
			if attached base_url as l_base_url then
				Result := l_base_url + a_resource
			else
				Result := a_resource
			end
		end

feature {WSF_ROUTED_SERVICE_I} -- Handler

	handler (req: WSF_REQUEST): detachable TUPLE [handler: attached like default_handler; context: like default_handler_context]
		local
			l_handlers: like handlers
			t: READABLE_STRING_8
			p: READABLE_STRING_8
			l_req_method: READABLE_STRING_GENERAL
			l_res: URI_TEMPLATE_MATCH_RESULT
		do
			p := source_uri (req)
			from
				l_req_method := req.request_method
				l_handlers := handlers
				l_handlers.start
			until
				l_handlers.after or Result /= Void
			loop
				if attached l_handlers.item as l_info then
					if is_matching_request_methods (l_req_method, l_info.request_methods) then
						t := l_info.resource
						if
							attached {WSF_ROUTING_HANDLER  [H, C]} l_info.handler as rah and then
							p.starts_with (t)
						then
							create l_res.make_empty
							l_res.path_variables.force (p.substring (t.count + 1, p.count), "path")

							Result := [l_info.handler, handler_context (p, req, create {URI_TEMPLATE}.make (t), l_res)]
						elseif attached templates.item (t) as tpl and then
							attached tpl.match (p) as res
						then
							Result := [l_info.handler, handler_context (p, req, tpl, res)]
						end
					end
				end
				l_handlers.forth
			end
		end

feature {NONE} -- Context factory

	handler_context (p: detachable READABLE_STRING_8; req: WSF_REQUEST; tpl: URI_TEMPLATE; tpl_res: URI_TEMPLATE_MATCH_RESULT): C
		do
			if p /= Void then
				create Result.make (req, tpl, tpl_res, p)
			else
				create Result.make (req, tpl, tpl_res, source_uri (req))
			end
		end

feature -- Access: ITERABLE

	new_cursor: ITERATION_CURSOR [TUPLE [handler: H; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Fresh cursor associated with current structure
		do
			Result := handlers.new_cursor
		end

feature {NONE} -- Implementation

	handlers: ARRAYED_LIST [TUPLE [handler: H; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Handlers indexed by the template expression
			-- see `templates'

	templates: HASH_TABLE [URI_TEMPLATE, READABLE_STRING_8]
			-- URI Template indexed by the template expression

	context_path (a_path: STRING): STRING
			-- Prepared path from context which match requirement
			-- i.e: not empty, starting with '/'
		local
			p: INTEGER
		do
			Result := a_path
			if Result.is_empty then
				Result := "/"
			else
				if Result[1] /= '/' then
					Result := "/" + Result
				end
				p := Result.index_of ('.', 1)
				if p > 0 then
					Result := Result.substring (1, p - 1)
				end
			end
		ensure
			result_not_empty: not Result.is_empty
		end

feature {NONE} -- Default: implementation		

	default_handler: detachable H

	set_default_handler (h: like default_handler)
		do
			default_handler := h
		end

	default_handler_context (req: WSF_REQUEST): C
		do
			Result := handler_context (Void, req, create {URI_TEMPLATE}.make ("/"), create {URI_TEMPLATE_MATCH_RESULT}.make_empty)
		end

;note
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
