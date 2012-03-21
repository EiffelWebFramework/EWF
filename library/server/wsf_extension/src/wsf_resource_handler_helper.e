note
	description: "Work in progress Common abstraction to handle RESTfull methods"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_RESOURCE_HANDLER_HELPER [C -> WSF_HANDLER_CONTEXT]

feature -- Execute template

	execute_methods (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request and dispatch according to the request method
		local
			m: READABLE_STRING_8
		do
			m := req.request_method.as_upper
			if     m.same_string ({HTTP_REQUEST_METHODS}.method_get) then
				execute_get (ctx, req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_put) then
				execute_put (ctx, req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_delete) then
				execute_delete (ctx, req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_post) then
				execute_post (ctx, req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_trace) then
				execute_trace (ctx, req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_options) then
				execute_options (ctx, req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_head) then
				execute_head (ctx, req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_connect) then
				execute_connect (ctx, req, res)
			else
					--| Eventually handle other methods...
				execute_extension_method (ctx, req, res)
			end
		end

feature -- Method Post

	execute_post (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if req.is_chunked_input then
				do_post (ctx, req, res)
			else
				if req.content_length_value > 0 then
					do_post (ctx, req, res)
				else
					handle_bad_request_response ("Bad request, content_length empty", ctx, req, res)
				end
			end
		end

	do_post (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method POST not implemented", ctx, req, res)
		end

feature-- Method Put

	execute_put (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if req.is_chunked_input then
				do_put (ctx, req, res)
			else
				if req.content_length_value > 0 then
					do_put (ctx, req, res)
				else
					handle_bad_request_response ("Bad request, content_length empty", ctx, req, res)
				end
			end
		end

	do_put (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method PUT not implemented", ctx, req, res)
		end

feature -- Method Get

	execute_get (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_get (ctx, req, res)
		end

	do_get (ctx: C;req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method GET not implemented", ctx, req, res)
		end

feature -- Method DELETE

	execute_delete (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_delete (ctx, req, res)
		end

	do_delete (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method DELETE not implemented", ctx, req, res)
		end

feature -- Method CONNECT

	execute_connect (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_connect (ctx, req, res)
		end

	do_connect (ctx: C;req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method CONNECT not implemented", ctx, req, res)
		end

feature -- Method HEAD

	execute_head (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_head (ctx, req, res)
		end

	do_head (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method HEAD not implemented", ctx, req, res)
		end

feature -- Method OPTIONS

	execute_options (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_options (ctx, req, res)
		end

	do_options (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method OPTIONS not implemented", ctx, req, res)
		end

feature -- Method TRACE

	execute_trace (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_trace (ctx, req, res)
		end

	do_trace (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method TRACE not implemented", ctx, req, res)
		end

feature -- Method Extension Method

	execute_extension_method (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_extension_method (ctx, req, res)
		end

	do_extension_method (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method extension-method not implemented", ctx, req, res)
		end

feature -- Retrieve content from WGI_INPUT_STREAM

	retrieve_data  ( req : WSF_REQUEST) : STRING
			-- retrieve the content from the input stream
			-- handle differents transfers
		do
			Result := ""
			if req.is_chunked_input then
				if attached req.chunked_input as l_chunked_input then
					Result := l_chunked_input.data.as_string_8
				end
			else
				req.input.read_string (req.content_length_value.as_integer_32)
				Result := req.input.last_string
			end
		end

feature -- Handle responses
	-- TODO Handle Content negotiation.
	-- The option : Server-driven negotiation: uses request headers to select a variant
	-- More info : http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12

	supported_content_types: detachable ARRAY [READABLE_STRING_8]
			-- Supported content types
			-- Can be redefined
		do
			Result := Void
		end

	handle_bad_request_response (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE )
		local
			h : HTTP_HEADER
		do
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.bad_request)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end


	handle_precondition_fail_response (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE )
		local
			h : HTTP_HEADER
		do
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.precondition_failed)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end

	handle_internal_server_error (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE )
		local
			h : HTTP_HEADER
		do
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.internal_server_error)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end

	handle_not_implemented (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE )
		local
			h : HTTP_HEADER
		do
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.not_implemented)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end

	handle_method_not_allowed_response (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h : HTTP_HEADER
		do
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end

	handle_resource_not_found_response (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h : HTTP_HEADER
		do
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.not_found)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end


	handle_resource_not_modified_response (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h : HTTP_HEADER
		do
			res.flush
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.not_modified)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end


	handle_resource_conflict_response (a_description: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h : HTTP_HEADER
		do
			create h.make
			h.put_content_type_application_json
			h.put_content_length (a_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.conflict)
			res.put_header_text (h.string)
			res.put_string (a_description)
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
