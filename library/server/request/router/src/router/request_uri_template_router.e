note
	description: "Summary description for {REQUEST_URI_TEMPLATE_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_TEMPLATE_ROUTER

inherit
	REQUEST_ROUTER

create
	make

feature -- Initialization

	make (n: INTEGER)
		do
			create handlers.make (n)
			create templates.make (n)
			handlers.compare_objects
		end

feature -- Registration

	map_with_uri_template (uri: URI_TEMPLATE; h: REQUEST_HANDLER)
		do
			map_with_uri_template_and_request_methods (uri, h, Void)
		end

	map_with_uri_template_and_request_methods (uri: URI_TEMPLATE; h: REQUEST_HANDLER; rqst_methods: detachable ARRAY [READABLE_STRING_8])
		do
			handlers.force ([h, uri.template, formatted_request_methods (rqst_methods)])
			templates.force (uri, uri.template)
		end

	map_with_request_methods (tpl: READABLE_STRING_8; h: REQUEST_HANDLER; rqst_methods: detachable ARRAY [READABLE_STRING_8])
		local
			uri: URI_TEMPLATE
		do
			create uri.make (tpl)
			map_with_uri_template_and_request_methods (uri, h, rqst_methods)
		end

feature {NONE} -- Access: Implementation

	handler (req: WGI_REQUEST): detachable TUPLE [handler: REQUEST_HANDLER; context: REQUEST_HANDLER_CONTEXT]
		local
			ctx: detachable REQUEST_URI_TEMPLATE_HANDLER_CONTEXT
			l_handlers: like handlers
			t: STRING
			p: STRING
			l_req_method: READABLE_STRING_GENERAL
		do
			p := req.request_uri
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
						if attached templates.item (t) as tpl and then
							attached tpl.match (p) as res
						then
							ctx := handler_context (p, req, tpl, res)
							Result := [l_info.handler, ctx]
						end
					end
				end
				l_handlers.forth
			end
		end

feature -- Context factory

	handler_context (p: detachable STRING; req: WGI_REQUEST; tpl: URI_TEMPLATE; tpl_res: URI_TEMPLATE_MATCH_RESULT): REQUEST_URI_TEMPLATE_HANDLER_CONTEXT
		do
			if p /= Void then
				create Result.make (req, tpl, tpl_res, p)
			else
				create Result.make (req, tpl, tpl_res, req.path_info)
			end
		end

feature -- Access: ITERABLE

	new_cursor: ITERATION_CURSOR [TUPLE [handler: REQUEST_HANDLER; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Fresh cursor associated with current structure
		do
			Result := handlers.new_cursor
		end

feature {NONE} -- Implementation

	handlers: ARRAYED_LIST [TUPLE [handler: REQUEST_HANDLER; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
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
