note
	description: "Summary description for {REQUEST_URI_TEMPLATE_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_TEMPLATE_ROUTER

inherit
	REQUEST_ROUTER

	ITERABLE [REQUEST_HANDLER]
		redefine
			new_cursor
		end

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
			handlers.force (h, uri.template)
			templates.force (uri, uri.template)
		end

	map (tpl: STRING; h: REQUEST_HANDLER)
		local
			uri: URI_TEMPLATE
		do
			create uri.make (tpl)
			map_with_uri_template (uri, h)
		end

feature {NONE} -- Access: Implementation

	handler (req: EWSGI_REQUEST): detachable TUPLE [handler: REQUEST_HANDLER; context: REQUEST_HANDLER_CONTEXT]
		local
			ctx: detachable REQUEST_URI_TEMPLATE_HANDLER_CONTEXT
			l_handlers: like handlers
			t: STRING
			p: STRING
		do
			p := req.environment.request_uri
			from
				l_handlers := handlers
				l_handlers.start
			until
				l_handlers.after or Result /= Void
			loop
				t := l_handlers.key_for_iteration
				if attached templates.item (t) as tpl and then
					attached tpl.match (p) as res
				then
					ctx := handler_context (p, req, tpl, res)
					Result := [l_handlers.item_for_iteration, ctx]
				end
				l_handlers.forth
			end
		end

feature -- Context factory

	handler_context (p: detachable STRING; req: EWSGI_REQUEST; tpl: URI_TEMPLATE; tpl_res: URI_TEMPLATE_MATCH_RESULT): REQUEST_URI_TEMPLATE_HANDLER_CONTEXT
		do
			if p /= Void then
				create Result.make (req, tpl, tpl_res, p)
			else
				create Result.make (req, tpl, tpl_res, req.environment.path_info)
			end
		end

feature -- Access

	new_cursor: HASH_TABLE_ITERATION_CURSOR [REQUEST_HANDLER, STRING]
			-- Fresh cursor associated with current structure
		do
			Result := handlers.new_cursor
		end

	item (a_path: STRING): detachable REQUEST_HANDLER
		do
			Result := handlers.item (a_path)
		end

feature {NONE} -- Implementation

	handlers: HASH_TABLE [REQUEST_HANDLER, STRING]
			-- Handlers indexed by the template expression
			-- see `templates'

	templates: HASH_TABLE [URI_TEMPLATE, STRING]
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
