note
	description: "Work in progress Common abstraction to handle RESTfull methods"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_RESOURCE_HANDLER_HELPER

feature -- Execute template

	execute_methods (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request and dispatch according to the request method
		local
			m: READABLE_STRING_8
		do
			m := req.request_method.as_upper
			if     m.same_string ({HTTP_REQUEST_METHODS}.method_get) then
				execute_get (req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_put) then
				execute_put (req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_delete) then
				execute_delete (req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_post) then
				execute_post (req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_trace) then
				execute_trace (req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_options) then
				execute_options (req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_head) then
				execute_head (req, res)
			elseif m.same_string ({HTTP_REQUEST_METHODS}.method_connect) then
				execute_connect (req, res)
			else
					--| Eventually handle other methods...
				execute_extension_method (req, res)
			end
		end

feature -- Method Post

	execute_post (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if req.is_chunked_input then
				do_post (req, res)
			else
				if req.content_length_value > 0 then
					do_post (req, res)
				else
					handle_bad_request_response ("Bad request, content_length empty", req, res)
				end
			end
		end

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method POST not implemented",  req, res)
		end

feature-- Method Put

	execute_put (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if req.is_chunked_input then
				do_put (req, res)
			else
				if req.content_length_value > 0 then
					do_put (req, res)
				else
					handle_bad_request_response ("Bad request, content_length empty", req, res)
				end
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method PUT not implemented", req, res)
		end

feature -- Method Get

	execute_get (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_get (req, res)
		end

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method GET not implemented", req, res)
		end

feature -- Method DELETE

	execute_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_delete (req, res)
		end

	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method DELETE not implemented", req, res)
		end

feature -- Method CONNECT

	execute_connect (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_connect (req, res)
		end

	do_connect (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method CONNECT not implemented", req, res)
		end

feature -- Method HEAD

	execute_head (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_head (req, res)
		end

	do_head (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method HEAD not implemented", req, res)
		end

feature -- Method OPTIONS

	execute_options (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_options (req, res)
		end

	do_options (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method OPTIONS not implemented", req, res)
		end

feature -- Method TRACE

	execute_trace (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_trace (req, res)
		end

	do_trace (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method TRACE not implemented", req, res)
		end

feature -- Method Extension Method

	execute_extension_method (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			do_extension_method (req, res)
		end

	do_extension_method (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			handle_not_implemented ("Method extension-method not implemented", req, res)
		end

feature -- Retrieve content from WGI_INPUT_STREAM

	retrieve_data  ( req : WSF_REQUEST) : STRING
			-- retrieve the content from the input stream
			-- handle differents transfers
		local
			l_input: WGI_INPUT_STREAM
			n: INTEGER
			s: STRING
		do
			if req.is_chunked_input then
				l_input := req.input
				from
					n := 1_024
					create Result.make (n)
				until
					n = 0
				loop
					l_input.read_string (n)
					s := l_input.last_string
					if s.count = 0 then
						n := 0
					else
						if s.count < n then
							n := 0
						end
						Result.append (s)
					end
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

	handle_bad_request_response (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE )
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

	handle_precondition_fail_response (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE )
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

	handle_internal_server_error (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE )
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

	handle_not_implemented (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE )
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

	handle_method_not_allowed_response (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
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

	handle_resource_not_found_response (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
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


	handle_resource_not_modified_response (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
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


	handle_resource_conflict_response (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
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
