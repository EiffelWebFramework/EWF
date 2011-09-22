note
	description: "Summary description for {ORDER_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORDER_HANDLER[C -> REQUEST_HANDLER_CONTEXT]
inherit
	REQUEST_HANDLER[C]
	SHARED_DATABASE_API
	SHARED_EJSON
	REFACTORING_HELPER
	SHARED_ORDER_VALIDATION
	WGI_RESPONSE_STATUS_CODES

feature -- execute
	execute (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute request handler	
		do
				if req.request_method.same_string ("GET") then
--					pre_process_get (ctx, a_format, a_args)
				elseif req.request_method.same_string ("PUT")  then
--					pre_process_put (ctx, a_format, a_args)
				elseif req.request_method.same_string ("DELETE")  then
--					pre_process_delete (ctx, a_format, a_args)
				elseif req.request_method.same_string ("POST")  then
					process_post (ctx,req,res)
				else
					-- TODO HANDLE METHOD NOT SUPPORTED
				end
		end

feature -- HTTP Methods

	process_post (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			l_values: HASH_TABLE [STRING_32, STRING]
			l_missings: LINKED_LIST [STRING]
			l_full: BOOLEAN
			l_post: STRING
			l_location :  STRING
			l_msg      : STRING
			l_order : detachable ORDER
			jv : detachable JSON_VALUE
			h : EWF_HEADER
		do
				fixme ("TODO handle an Internal Server Error")
				fixme ("Refactor the code, create new abstractions")
				fixme ("Add Header Date to the response")
				if  req.content_length_value > 0 then
					req.input.read_stream (req.content_length_value.as_integer_32)
					l_post := req.input.last_string
					l_order := extract_order_request(l_post)
					fixme ("TODO move to a service method")
					if  l_order /= Void then
						save_order( l_order)
						create h.make
						h.put_status (created)
						h.put_content_type ("application/json")
						jv ?= json.value (l_order)
						if jv /= Void then
							l_msg := jv.representation
							h.put_content_length (l_msg.count)
							if attached req.http_host as host then
								l_location := "http://"+host +"/" +req.request_uri+"/" + l_order.id
								h.add_header ("Location:"+ l_location)
							end
							res.set_status_code (created)
							res.write_headers_string (h.string)
							res.write_string (l_msg)
						end
					else
--						handle_bad_request_response(l_post +"%N is not a valid ORDER",ctx.output)
					end
				else
--					handle_bad_request_response("Bad request, content_lenght empty",ctx.output)
				end
		end


feature -- Implementation

	save_order ( an_order : ORDER)
		-- save the order to the repository
		local
			i : INTEGER
		do
				from
					i := 1
				until
					not db_access.orders.has_key ((db_access.orders.count + i).out)
				loop
					i := i + 1
				end
				an_order.set_id ((db_access.orders.count + i).out)
				an_order.set_status ("submitted")
				an_order.add_revision
				db_access.orders.force (an_order, an_order.id)
		end

--	update_order ( an_order : ORDER)
--		-- update the order to the repository
--		do
--			an_order.add_revision
--			db_access.orders.force (an_order, an_order.id)
--		end

--	delete_order ( an_order : STRING)
--		-- update the order to the repository
--		do
--			db_access.orders.remove (an_order)
--		end

	extract_order_request (l_post : STRING) : detachable ORDER
		-- extract an object Order from the request, or Void
		-- if the request is invalid
		local
			joc : JSON_ORDER_CONVERTER
			parser : JSON_PARSER
			l_order : detachable ORDER
			jv : detachable JSON_VALUE
		do
			create joc.make
			json.add_converter(joc)
			create parser.make_parser (l_post)
			jv ?= parser.parse
			if jv /= Void and parser.is_parsed then
				l_order ?= json.object (jv, "ORDER")
				Result :=  l_order
			end
		end


--	handle_bad_request_response (a_description:STRING; an_output: HTTPD_SERVER_OUTPUT )
--		local
--			rep: detachable REST_RESPONSE
--		do
--					create rep.make (path)
--					rep.headers.put_status (rep.headers.bad_request)
--					rep.headers.put_content_type_application_json
--					rep.set_message (a_description)
--					an_output.put_string (rep.string)
--					rep.recycle
--		end

--	handle_conflic_request_response (a_description:STRING; an_output: HTTPD_SERVER_OUTPUT )
--		local
--			rep: detachable REST_RESPONSE
--		do
--					create rep.make (path)
--					rep.headers.put_status (rep.headers.conflict)
--					rep.headers.put_content_type_application_json
--					rep.set_message (a_description)
--					an_output.put_string (rep.string)
--					rep.recycle
--		end


--	handle_resource_not_found_response (a_description:STRING; an_output: HTTPD_SERVER_OUTPUT )
--		local
--			rep: detachable REST_RESPONSE
--		do
--					create rep.make (path)
--					rep.headers.put_status (rep.headers.not_found)
--					rep.headers.put_content_type_application_json
--					rep.set_message (a_description)
--					an_output.put_string (rep.string)
--					rep.recycle
--		end


--	handle_method_not_supported_response (ctx :REST_REQUEST_CONTEXT)
--		local
--			rep: detachable REST_RESPONSE
--		do
--					create rep.make (path)
--					rep.headers.put_status (rep.headers.method_not_allowed)
--					rep.headers.put_content_type_application_json
--					ctx.output.put_string (rep.string)
--					rep.recycle
--		end

end
