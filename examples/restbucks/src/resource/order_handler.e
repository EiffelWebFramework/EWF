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
					process_get (ctx,req,res)
				elseif req.request_method.same_string ("PUT")  then
					process_put (ctx,req,res)
				elseif req.request_method.same_string ("DELETE")  then
					process_delete (ctx,req,res)
				elseif req.request_method.same_string ("POST")  then
					process_post (ctx,req,res)
				end
		end

feature -- API DOC
	api_doc : STRING = "URI:/order METHOD: POST%N URI:/order/{orderid} METHOD: GET, PUT, DELETE%N"
feature -- HTTP Methods

	process_get (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			l_values: HASH_TABLE [STRING_32, STRING]
			l_missings: LINKED_LIST [STRING]
			l_full: BOOLEAN
			l_post: STRING
			joc : JSON_ORDER_CONVERTER
			parser : JSON_PARSER
			l_order : detachable ORDER
			jv : detachable JSON_VALUE
			l_location, id :  STRING
			uri : LIST[READABLE_STRING_32]
			h : EWF_HEADER
			http_if_not_match : STRING
		do
				fixme ("TODO handle error conditions")
				if  attached req.orig_path_info as orig_path then
					uri := orig_path.split ('/')
					id := uri.at (3)
					create joc.make
					json.add_converter(joc)
					if db_access.orders.has_key (id) then
						l_order := db_access.orders.item (id)
						jv ?= json.value (l_order)
						if attached jv as j then
							create h.make
							h.put_status (ok)
							h.put_content_type ("application/json")
							if attached req.request_time as time then
								h.add_header ("Date:" +time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
							end
							if l_order /= Void then
								h.add_header ("Etag: " + l_order.etag)
							end
							res.set_status_code (ok)
							res.write_headers_string (h.string)
							res.write_string (j.representation)
						end
					else
						handle_resource_not_found_response ("The following resource"+ orig_path+ " is not found ", res)
					end
				end


		end

	process_put (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			l_values: HASH_TABLE [STRING_32, STRING]
			l_missings: LINKED_LIST [STRING]
			l_full: BOOLEAN
			l_post: STRING
			l_location :  STRING
			l_order : detachable ORDER
			jv : detachable JSON_VALUE
			h : EWF_HEADER
		do
				fixme ("TODO handle an Internal Server Error")
				fixme ("Refactor the code, create new abstractions")
				fixme ("Add Header Date to the response")
				fixme ("Put implememntation is wrong!!!!")
				if req.content_length_value > 0 then
					req.input.read_stream (req.content_length_value.as_integer_32)
					l_post := req.input.last_string
					l_order := extract_order_request(l_post)
					fixme ("TODO move to a service method")
					if  l_order /= Void and then db_access.orders.has_key (l_order.id) then
						update_order( l_order)
							create h.make
							h.put_status (ok)
							h.put_content_type ("application/json")
							if attached req.request_time as time then
								h.add_header ("Date:" +time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
							end
						if attached req.http_host as host then
							l_location := "http://"+host +req.request_uri+"/" + l_order.id
							h.add_header ("Location:"+ l_location)
						end
						jv ?= json.value (l_order)
						if jv /= Void then
							h.put_content_length (jv.representation.count)
							res.set_status_code (ok)
							res.write_headers_string (h.string)
							res.write_string (jv.representation)
						end
					else
						handle_bad_request_response(l_post +"%N is not a valid ORDER, maybe the order does not exist in the system",res)
					end
				else
					handle_bad_request_response("Bad request, content_lenght empty",res)
				end
		end


	process_delete (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			l_values: HASH_TABLE [STRING_32, STRING]
			uri: LIST [READABLE_STRING_32]
			l_full: BOOLEAN
			id: STRING
			l_location :  STRING
			l_order : detachable ORDER
			jv : detachable JSON_VALUE
			h : EWF_HEADER
		do
				fixme ("TODO handle an Internal Server Error")
				fixme ("Refactor the code, create new abstractions")
				if  attached req.orig_path_info as orig_path then
					uri := orig_path.split ('/')
					id := uri.at (3)
					if  db_access.orders.has_key (id) then
						delete_order( id)
						create h.make
						h.put_status (no_content)
						h.put_content_type ("application/json")
						if attached req.request_time as time then
								h.add_header ("Date:" +time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
						end
						res.set_status_code (no_content)
						res.write_headers_string (h.string)
					else
						handle_resource_not_found_response (orig_path + " not found in this server", res)
					end
				end
		end

	process_post (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		-- Here the convention is the following.
		-- POST is used for creation and the server determines the URI
		-- of the created resource.
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
				fixme ("Refactor the code, We need an Extract Method tool :)")
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
								l_location := "http://"+host +req.request_uri+"/" + l_order.id
								h.add_header ("Location:"+ l_location)
							end
							if attached req.request_time as time then
								h.add_header ("Date:" +time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
							end
							res.set_status_code (created)
							res.write_headers_string (h.string)
							res.write_string (l_msg)
						end
					else
						handle_bad_request_response(l_post +"%N is not a valid ORDER",res)
					end
				else
					handle_bad_request_response("Bad request, content_lenght empty",res)
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

	update_order ( an_order : ORDER)
		-- update the order to the repository
		do
			an_order.add_revision
			db_access.orders.force (an_order, an_order.id)
		end

	delete_order ( an_order : STRING)
		-- update the order to the repository
		do
			db_access.orders.remove (an_order)
		end

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


	handle_bad_request_response (a_description:STRING; res: WGI_RESPONSE_BUFFER )
		local
			h : EWF_HEADER
		do
					create h.make
					h.put_status (bad_request)
					h.put_content_type ("application/json")
					h.put_content_length (a_description.count)
					h.add_header ("Date:"+ ((create{HTTP_DATE_TIME_UTILITIES}).now_utc).formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
					res.set_status_code (bad_request)
					res.write_headers_string (h.string)
					res.write_string (a_description)
		end



	handle_not_implemented (a_description:STRING; res: WGI_RESPONSE_BUFFER )
		local
			h : EWF_HEADER
		do
					create h.make
					h.put_status (not_implemented)
					h.put_content_type ("application/json")
					h.put_content_length (a_description.count)
					h.add_header ("Date:"+ ((create{HTTP_DATE_TIME_UTILITIES}).now_utc).formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
					res.set_status_code (not_implemented)
					res.write_headers_string (h.string)
					res.write_string (a_description)
		end

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


	handle_resource_not_found_response (a_description:STRING; res: WGI_RESPONSE_BUFFER)
		local
			h : EWF_HEADER
		do
					create h.make
					h.put_status (not_found)
					h.put_content_type ("application/json")
					h.put_content_length (a_description.count)
					h.add_header ("Date:"+ ((create{HTTP_DATE_TIME_UTILITIES}).now_utc).formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
					res.set_status_code (not_found)
					res.write_headers_string (h.string)
					res.write_string (a_description)
		end


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
