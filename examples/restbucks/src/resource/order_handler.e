note
	description: "Summary description for {ORDER_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORDER_HANDLER [C -> REQUEST_HANDLER_CONTEXT]
inherit
	REQUEST_HANDLER [C]
	REQUEST_RESOURCE_HANDLER_HELPER [C]
		redefine
			do_get,
			do_post,
			do_put,
			do_delete
		end
	SHARED_DATABASE_API
	SHARED_EJSON
	REFACTORING_HELPER
	SHARED_ORDER_VALIDATION

feature -- execute

	execute (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute request handler	
		do
			execute_methods (ctx, req, res)
		end

feature -- API DOC

	api_doc : STRING = "URI:/order METHOD: POST%N URI:/order/{orderid} METHOD: GET, PUT, DELETE%N"

feature -- HTTP Methods

	do_get (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Using GET to retrieve resource information.
			-- If the GET request is SUCCESS, we response with
			-- 200 OK, and a representation of the order
			-- If the GET request is not SUCCESS, we response with
			-- 404 Resource not found
		local
			id :  STRING
		do
			if attached req.orig_path_info as orig_path then
				id := get_order_id_from_path (orig_path)
				if attached retrieve_order (id) as l_order then
					compute_response_get (ctx, req, res, l_order)
				else
					handle_resource_not_found_response ("The following resource" + orig_path + " is not found ", ctx, req, res)
				end
			end
		end

	compute_response_get (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER; l_order : ORDER)
		local
			h: EWF_HEADER
			l_msg : STRING
		do
			create h.make
			h.put_status ({HTTP_STATUS_CODE}.ok)
			h.put_content_type_application_json
			if attached {JSON_VALUE} json.value (l_order) as jv then
				l_msg := jv.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.write_headers_string (h.string)
				res.write_string (l_msg)
			end
		end

	do_put (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			l_post: STRING
			l_location :  STRING
			l_order : detachable ORDER
			h : EWF_HEADER
		do
			fixme ("TODO handle an Internal Server Error")
			fixme ("Refactor the code, create new abstractions")
			fixme ("Add Header Date to the response")
			fixme ("Put implementation is wrong!!!!")
			req.input.read_stream (req.content_length_value.as_integer_32)
			l_post := req.input.last_string
			l_order := extract_order_request(l_post)
			fixme ("TODO move to a service method")
			if  l_order /= Void and then db_access.orders.has_key (l_order.id) then
				update_order( l_order)
				create h.make
				h.put_status ({HTTP_STATUS_CODE}.ok)
				h.put_content_type ("application/json")
				if attached req.request_time as time then
					h.add_header ("Date:" +time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				if attached req.http_host as host then
					l_location := "http://"+host +req.request_uri+"/" + l_order.id
					h.add_header ("Location:"+ l_location)
				end
				if attached {JSON_VALUE} json.value (l_order) as jv then
					h.put_content_length (jv.representation.count)
					res.set_status_code ({HTTP_STATUS_CODE}.ok)
					res.write_headers_string (h.string)
					res.write_string (jv.representation)
				end
			else
				handle_bad_request_response (l_post +"%N is not a valid ORDER, maybe the order does not exist in the system", ctx, req, res)
			end
		end

	do_delete (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			id: STRING
			h : EWF_HEADER
		do
			fixme ("TODO handle an Internal Server Error")
			fixme ("Refactor the code, create new abstractions")
			if  attached req.orig_path_info as orig_path then
				id := get_order_id_from_path (orig_path)
				if db_access.orders.has_key (id) then
					delete_order( id)
					create h.make
					h.put_status ({HTTP_STATUS_CODE}.no_content)
					h.put_content_type ("application/json")
					if attached req.request_time as time then
						h.put_utc_date (time)
					end
					res.set_status_code ({HTTP_STATUS_CODE}.no_content)
					res.write_headers_string (h.string)
				else
					handle_resource_not_found_response (orig_path + " not found in this server", ctx, req, res)
				end
			end
		end

	do_post (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Here the convention is the following.
			-- POST is used for creation and the server determines the URI
			-- of the created resource.
			-- If the request post is SUCCESS, the server will create the order and will response with
			-- HTTP_RESPONSE 201 CREATED, the Location header will contains the newly created order's URI
			-- if the request post is not SUCCESS, the server will response with
			-- HTTP_RESPONSE 400 BAD REQUEST, the client send a bad request
			-- HTTP_RESPONSE 500 INTERNAL_SERVER_ERROR, when the server can deliver the request
		local
			l_post: STRING
		do
			req.input.read_stream (req.content_length_value.as_integer_32)
			l_post := req.input.last_string
			if attached extract_order_request (l_post) as l_order then
				save_order (l_order)
				compute_response_post (ctx, req, res, l_order)
			else
				handle_bad_request_response (l_post +"%N is not a valid ORDER", ctx, req, res)
			end
		end

	compute_response_post (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER; l_order : ORDER)
		local
			h: EWF_HEADER
			l_msg : STRING
			l_location :  STRING
			joc : JSON_ORDER_CONVERTER
		do
			create h.make

			create joc.make
			json.add_converter(joc)

			h.put_status ({HTTP_STATUS_CODE}.created)
			h.put_content_type_application_json
			if attached {JSON_VALUE} json.value (l_order) as jv then
				l_msg := jv.representation
				h.put_content_length (l_msg.count)
				if attached req.http_host as host then
					l_location := "http://" + host + req.request_uri + "/" + l_order.id
					h.put_location (l_location)
				end
				if attached req.request_time as time then
					h.put_utc_date (time)
				end
				res.set_status_code ({HTTP_STATUS_CODE}.created)
				res.write_headers_string (h.string)
				res.write_string (l_msg)
			end
		end

feature {NONE} -- URI helper methods

	get_order_id_from_path (a_path: READABLE_STRING_32) : STRING
		do
			Result := a_path.split ('/').at (3)
		end

feature {NONE} -- Implementation Repository Layer

	retrieve_order ( id : STRING) : detachable ORDER
			-- get the order by id if it exist, in other case, Void
		do
			Result := db_access.orders.item (id)
		end

	save_order (an_order: ORDER)
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

	update_order (an_order: ORDER)
			-- update the order to the repository
		do
			an_order.add_revision
			db_access.orders.force (an_order, an_order.id)
		end

	delete_order (an_order: STRING)
			-- update the order to the repository
		do
			db_access.orders.remove (an_order)
		end

	extract_order_request (l_post : STRING) : detachable ORDER
			-- extract an object Order from the request, or Void
			-- if the request is invalid
		local
			parser : JSON_PARSER
			joc : JSON_ORDER_CONVERTER
		do
			create joc.make
			json.add_converter(joc)
			create parser.make_parser (l_post)
			if attached parser.parse as jv and parser.is_parsed then
				Result ?= json.object (jv, "ORDER")
			end
		end

note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
