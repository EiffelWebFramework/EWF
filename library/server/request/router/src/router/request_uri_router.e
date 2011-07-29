note
	description: "Summary description for {REQUEST_URI_ROUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_URI_ROUTER

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
			handlers.compare_objects
		end

feature -- Registration

	map (p: STRING; h: REQUEST_HANDLER)
		do
			handlers.force (h, p)
		end

feature {NONE} -- Access: Implementation

	handler (req: EWSGI_REQUEST): detachable TUPLE [handler: REQUEST_HANDLER; context: REQUEST_HANDLER_CONTEXT]
		local
			h: detachable REQUEST_HANDLER
			ctx: detachable REQUEST_HANDLER_CONTEXT
		do
			h := handler_by_path (req.environment.path_info)
			if h = Void then
				if attached smart_handler_by_path (req.environment.path_info) as info then
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

	smart_handler (req: EWSGI_REQUEST): detachable TUPLE [path: STRING; handler: REQUEST_HANDLER]
		require
			req_valid: req /= Void and then req.environment.path_info /= Void
		do
			Result := smart_handler_by_path (req.environment.path_info)
		ensure
			req_path_info_unchanged: req.environment.path_info.same_string (old req.environment.path_info)
		end

	handler_by_path (a_path: STRING): detachable REQUEST_HANDLER
		require
			a_path_valid: a_path /= Void
		do
			Result := handlers.item (context_path (a_path))
		ensure
			a_path_unchanged: a_path.same_string (old a_path)
		end

	smart_handler_by_path (a_path: STRING): detachable TUPLE [path: STRING; handler: REQUEST_HANDLER]
		require
			a_path_valid: a_path /= Void
		local
			p: INTEGER
			l_context_path, l_path: STRING
			h: detachable REQUEST_HANDLER
		do
			l_context_path := context_path (a_path)
			from
				p := l_context_path.count + 1
			until
				p <= 1 or Result /= Void
			loop
				l_path := l_context_path.substring (1, p - 1)
				h := handler_by_path (l_path)
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

	handler_context (p: detachable STRING; req: EWSGI_REQUEST): REQUEST_URI_HANDLER_CONTEXT
		do
			if p /= Void then
				create Result.make (req, p)
			else
				create Result.make (req, req.environment.path_info)
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
			Result := handler_by_path (a_path)
		end

feature {NONE} -- Implementation

	handlers: HASH_TABLE [REQUEST_HANDLER, STRING]
			-- Handlers

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
