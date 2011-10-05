note
	description: "Summary description for {REQUEST_URI_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_ROUTER_I [H -> REQUEST_HANDLER [C], C -> REQUEST_URI_HANDLER_CONTEXT create make end]

inherit
	REQUEST_ROUTER [H, C]

create
	make

feature -- Initialization

	make (n: INTEGER)
		do
			create handlers.make (n)
			handlers.compare_objects
		end

feature -- Registration

	map_with_request_methods (p: READABLE_STRING_8; h: H; rqst_methods: detachable ARRAY [READABLE_STRING_8])
		local
			l_uri: READABLE_STRING_8
		do
			if attached base_url as l_base_url then
				l_uri := l_base_url + p
			else
				l_uri := p
			end
			handlers.force ([h, l_uri, formatted_request_methods (rqst_methods)])
			h.on_handler_mapped (l_uri, rqst_methods)
		end

feature {NONE} -- Access: Implementation

	handler (req: WGI_REQUEST): detachable TUPLE [handler: H; context: like default_handler_context]
		local
			h: detachable H
			ctx: detachable like default_handler_context
		do
			h := handler_by_path (source_uri (req), req.request_method)
			if h = Void then
				if attached smart_handler_by_path (source_uri (req), req.request_method) as info then
					h := info.handler
					ctx := handler_context (info.path, req)
				end
			end
			if h /= Void then
				if h.is_valid_context (req) then
					if ctx = Void then
						ctx := handler_context (Void, req)
					end
					Result := [h, ctx]
				else
					Result := Void
				end
			end
		end

	smart_handler (req: WGI_REQUEST): detachable TUPLE [path: READABLE_STRING_8; handler: H]
		require
			req_valid: req /= Void and then source_uri (req) /= Void
		do
			Result := smart_handler_by_path (source_uri (req), req.request_method)
		ensure
			req_path_info_unchanged: source_uri (req).same_string (old source_uri (req))
		end

	handler_by_path (a_path: READABLE_STRING_GENERAL; rqst_method: READABLE_STRING_GENERAL): detachable H
		require
			a_path_valid: a_path /= Void
		local
			l_handlers: like handlers
			l_item: like handlers.item
		do
			l_handlers := handlers
			from
				l_handlers.start
			until
				l_handlers.after or Result /= Void
			loop
				l_item := l_handlers.item
				if is_matching_request_methods (rqst_method, l_item.request_methods) and a_path.same_string (l_item.resource) then
					Result := l_item.handler
				end
				l_handlers.forth
			end
		ensure
			a_path_unchanged: a_path.same_string (old a_path)
		end

	smart_handler_by_path (a_path: READABLE_STRING_8; rqst_method: READABLE_STRING_GENERAL): detachable TUPLE [path: READABLE_STRING_8; handler: H]
		require
			a_path_valid: a_path /= Void
		local
			p: INTEGER
			l_context_path, l_path: READABLE_STRING_8
			h: detachable H
		do
			l_context_path := context_path (a_path)
			from
				p := l_context_path.count + 1
			until
				p <= 1 or Result /= Void
			loop
				l_path := l_context_path.substring (1, p - 1)
				h := handler_by_path (l_path, rqst_method)
				if h /= Void then
					Result := [l_path, h]
				else
					p := l_context_path.last_index_of ('/', p - 1)
				end
			variant
				p
			end
		ensure
			a_path_unchanged: a_path.same_string (old a_path)
		end

feature {NONE} -- Context factory

	handler_context (p: detachable STRING; req: WGI_REQUEST): C
		local
			ctx: C
		do
			if p /= Void then
				create ctx.make (req, p)
			else
				create ctx.make (req, source_uri (req))
			end
			Result := ctx
		end

feature -- Access

	new_cursor: ITERATION_CURSOR [TUPLE [handler: H; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Fresh cursor associated with current structure
		do
			Result := handlers.new_cursor
		end

feature {NONE} -- Implementation

	handlers: ARRAYED_LIST [TUPLE [handler: H; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Handlers indexed by the template expression
			-- see `templates'

	context_path (a_path: READABLE_STRING_8): READABLE_STRING_8
			-- Prepared path from context which match requirement
			-- i.e: not empty, starting with '/'
		local
			p: INTEGER
			s: STRING_8
		do
			Result := a_path
			if Result.is_empty then
				Result := "/"
			else
				if Result[1] /= '/' then
					create s.make_from_string (Result)
					s.prepend_character ('/')
					Result := s
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

	default_handler_context (req: WGI_REQUEST): C
		do
			Result := handler_context (Void, req)
		end

note
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
