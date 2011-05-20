class SHARED_HTTP_REQUEST_HANDLERS

feature

	http_request_handlers: HASH_TABLE [HTTP_REQUEST_HANDLER, STRING] is
		local
			a_handler: HTTP_REQUEST_HANDLER
		once
			create Result.make (5)
			create {GET_REQUEST_HANDLER} a_handler
			Result.put (a_handler, "GET")
		end
end
