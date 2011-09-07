note
	description: "Summary description for {REQUEST_URI_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_ROUTER

inherit
	REQUEST_ROUTER

create
	make

feature -- Initialization

	make (n: INTEGER)
		do
			create handlers.make (n)
			handlers.compare_objects
		end

feature -- Registration

	map_with_request_methods (p: READABLE_STRING_8; h: REQUEST_HANDLER; rqst_methods: detachable ARRAY [READABLE_STRING_8])
		do
			handlers.force ([h, p, formatted_request_methods (rqst_methods)])
		end

feature {NONE} -- Access: Implementation

	handler (req: WGI_REQUEST): detachable TUPLE [handler: REQUEST_HANDLER; context: REQUEST_HANDLER_CONTEXT]
		local
			h: detachable REQUEST_HANDLER
			ctx: detachable REQUEST_HANDLER_CONTEXT
		do
			h := handler_by_path (req.path_info, req.request_method)
			if h = Void then
				if attached smart_handler_by_path (req.path_info, req.request_method) as info then
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

	smart_handler (req: WGI_REQUEST): detachable TUPLE [path: READABLE_STRING_8; handler: REQUEST_HANDLER]
		require
			req_valid: req /= Void and then req.path_info /= Void
		do
			Result := smart_handler_by_path (req.path_info, req.request_method)
		ensure
			req_path_info_unchanged: req.path_info.same_string (old req.path_info)
		end

	handler_by_path (a_path: READABLE_STRING_GENERAL; rqst_method: READABLE_STRING_GENERAL): detachable REQUEST_HANDLER
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
--			Result := handlers.item (context_path (a_path))
		ensure
			a_path_unchanged: a_path.same_string (old a_path)
		end

	smart_handler_by_path (a_path: READABLE_STRING_8; rqst_method: READABLE_STRING_GENERAL): detachable TUPLE [path: READABLE_STRING_8; handler: REQUEST_HANDLER]
		require
			a_path_valid: a_path /= Void
		local
			p: INTEGER
			l_context_path, l_path: READABLE_STRING_8
			h: detachable REQUEST_HANDLER
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

feature -- Context factory

	handler_context (p: detachable STRING; req: WGI_REQUEST): REQUEST_URI_HANDLER_CONTEXT
		do
			if p /= Void then
				create Result.make (req, p)
			else
				create Result.make (req, req.path_info)
			end
		end

feature -- Access

	new_cursor: ITERATION_CURSOR [TUPLE [handler: REQUEST_HANDLER; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Fresh cursor associated with current structure
		do
			Result := handlers.new_cursor
		end

feature {NONE} -- Implementation

	handlers: ARRAYED_LIST [TUPLE [handler: REQUEST_HANDLER; resource: READABLE_STRING_8; request_methods: detachable ARRAY [READABLE_STRING_8]]]
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
