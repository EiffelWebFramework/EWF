note
	description: "Work in progress Common abstraction to handle REST methods"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_RESOURCE_HANDLER_HELPER[C -> REQUEST_HANDLER_CONTEXT]

inherit
	HTTP_STATUS_CODE

feature -- Execute template
	execute_methods (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			if req.request_method.same_string ("GET") then
					execute_get (ctx,req,res)
			elseif req.request_method.same_string ("PUT")  then
					execute_put (ctx,req,res)
			elseif req.request_method.same_string ("DELETE")  then
					execute_delete (ctx,req,res)
			elseif req.request_method.same_string ("POST")  then
					execute_post (ctx,req,res)
			elseif req.request_method.same_string ("TRACE")  then
					execute_trace (ctx,req,res)
			elseif req.request_method.same_string ("OPTIONS")  then
					execute_options (ctx,req,res)
			elseif req.request_method.same_string ("HEAD")  then
					execute_head (ctx,req,res)
			elseif req.request_method.same_string ("CONNECT")  then
					execute_connect (ctx,req,res)
--			elseif req.request_method.is_valid_extension_method then
--					execute_extension_method (req,res)
			end
		end


feature-- Method Post		
	execute_post (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			if  req.content_length_value > 0 then
				do_post (ctx,req,res)
			else
				handle_bad_request_response("Bad request, content_lenght empty", req.content_type, res)
			end
		rescue
			handle_internal_server_error("Internal Server Error",req.content_type,res)
		end

	do_post (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method POST not implemented", req.content_type, res)
		end



feature-- Method Put		
	execute_put (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			if  req.content_length_value > 0 then
				do_put (ctx,req,res)
			else
				handle_bad_request_response("Bad request, content_lenght empty", req.content_type, res)
			end
		rescue
			handle_internal_server_error("Internal Server Error", req.content_type,res)
		end

	do_put (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method PUT not implemented", req.content_type,res)
		end

feature -- Method Get
	execute_get (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			do_get (ctx,req,res)
		rescue
			handle_internal_server_error("Internal Server Error",req.content_type,res)
		end

	do_get (ctx: C;req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method HEAD not implemented", req.content_type, res)
		end

feature -- Method DELETE
	execute_delete (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			do_delete (ctx,req,res)
		rescue
			handle_internal_server_error("Internal Server Error",req.content_type,res)
		end

	do_delete (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method DELETE  not implemented", req.content_type, res)
		end

feature -- Method CONNECT
	execute_connect (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			do_connect (ctx,req,res)
		rescue
			handle_internal_server_error("Internal Server Error",req.content_type,res)
		end

	do_connect (ctx: C;req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method CONNECT  not implemented", req.content_type, res)
		end

feature -- Method HEAD
	execute_head (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			do_head (ctx,req,res)
		rescue
			handle_internal_server_error("Internal Server Error", req.content_type, res)
		end

	do_head (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method HEAD not implemented", req.content_type, res)
		end

feature -- Method OPTIONS
	execute_options (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			do_options (ctx,req,res)
		rescue
			handle_internal_server_error("Internal Server Error",req.content_type,res)
		end

	do_options (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method OPTIONS not implemented", req.content_type,res)
		end

feature -- Method TRACE
	execute_trace (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			do_trace (ctx,req,res)
		rescue
			handle_internal_server_error("Internal Server Error", req.content_type, res)
		end

	do_trace (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method TRACE not implemented", req.content_type,res)
		end

feature -- Method Extension Method
	execute_extension_method (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
	     do
			do_extension_method (ctx,req,res)
		rescue
			handle_internal_server_error("Internal Server Error",req.content_type,res)
		end

	do_extension_method (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
		    handle_not_implemented ("Method EXTENSION METHOD not implemented",req.content_type, res)
		end

feature -- Handle responses
	handle_bad_request_response (a_description:STRING;   content_type : detachable READABLE_STRING_32 ; res: WGI_RESPONSE_BUFFER )
		local
			h : EWF_HEADER
		do
					create h.make
					h.put_status (bad_request)
					if attached content_type as l_content_type then
						h.put_content_type (l_content_type)
					else
						h.put_content_type ("*/*")
					end
					h.put_content_length (a_description.count)
					h.add_header ("Date:"+ get_date)
					res.set_status_code (bad_request)
					res.write_headers_string (h.string)
					res.write_string (a_description)
		end



	handle_internal_server_error (a_description:STRING;  content_type : detachable READABLE_STRING_32 ; res: WGI_RESPONSE_BUFFER )
		local
			h : EWF_HEADER
		do
					create h.make
					h.put_status (internal_server_error)
					if attached content_type as l_content_type then
						h.put_content_type (l_content_type)
					else
						h.put_content_type ("*/*")
					end
					h.put_content_length (a_description.count)
					h.add_header ("Date:"+ get_date)
					res.set_status_code (internal_server_error)
					res.write_headers_string (h.string)
					res.write_string (a_description)
		end



	handle_not_implemented (a_description:STRING; content_type : detachable READABLE_STRING_32; res: WGI_RESPONSE_BUFFER )
		local
			h : EWF_HEADER
		do
					create h.make
					h.put_status (not_implemented)
					if attached content_type as l_content_type then
						h.put_content_type (l_content_type)
					else
						h.put_content_type ("*/*")
					end
					h.put_content_length (a_description.count)
					h.add_header ("Date:"+ get_date)
					res.set_status_code (not_implemented)
					res.write_headers_string (h.string)
					res.write_string (a_description)
		end


	handle_resource_not_found_response (a_description:STRING; content_type : detachable READABLE_STRING_32; res: WGI_RESPONSE_BUFFER)
		local
			h : EWF_HEADER
		do
					create h.make
					h.put_status (not_found)
					if attached content_type as l_content_type then
						h.put_content_type (l_content_type)
					else
						h.put_content_type ("*/*")
					end
					h.put_content_length (a_description.count)
					h.add_header ("Date:"+ get_date)
					res.set_status_code (not_found)
					res.write_headers_string (h.string)
					res.write_string (a_description)
		end

feature -- Date Utilities	
	get_date : STRING
		do
			Result := ((create{HTTP_DATE_TIME_UTILITIES}).now_utc).formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT"
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
