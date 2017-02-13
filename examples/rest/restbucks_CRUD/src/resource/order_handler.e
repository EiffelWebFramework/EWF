note
	description: "{ORDER_HANDLER} handle the resources that we want to expose"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORDER_HANDLER

inherit
	WSF_URI_TEMPLATE_HANDLER

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get,
			do_post,
			do_put,
			do_delete
		end

	SHARED_RESTBUCKS_API

	REFACTORING_HELPER

	WSF_SELF_DOCUMENTED_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_orderid_path_parameter_name: READABLE_STRING_GENERAL; a_router: WSF_ROUTER)
		do
			orderid_path_parameter_name := a_orderid_path_parameter_name
		end

	orderid_path_parameter_name: READABLE_STRING_GENERAL

feature -- Execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler	
		do
			execute_methods (req, res)
		end

feature -- Request parameters		

	order_id_from_request (req: WSF_REQUEST): detachable STRING_8
		do
			if attached {WSF_STRING} req.path_parameter (orderid_path_parameter_name) as p_id then
				Result := p_id.url_encoded_value -- the ORDER id has to be valid STRING 8 value.
			end
		end

feature -- API DOC

	api_doc : STRING = "URI:/order METHOD: POST%N URI:/order/{orderid} METHOD: GET, PUT, DELETE%N"


feature -- Documentation

	mapping_documentation (m: WSF_ROUTER_MAPPING; a_request_methods: detachable WSF_REQUEST_METHODS): WSF_ROUTER_MAPPING_DOCUMENTATION
		do
			create Result.make (m)
			if a_request_methods /= Void then
				if a_request_methods.has_method_post then
					Result.add_description ("URI:/order METHOD: POST")
				elseif
					a_request_methods.has_method_get
					or a_request_methods.has_method_put
					or a_request_methods.has_method_delete
				then
					Result.add_description ("URI:/order/{orderid} METHOD: GET, PUT, DELETE")
				end
			end
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			if
				attached order_id_from_request (req) as l_id and then
				attached order (l_id) as l_order
			then
				if is_conditional_get (req, l_order) then
					handle_resource_not_modified_response ("The resource" + req.percent_encoded_path_info + " does not change", req, res)
				else
					compute_response_get (req, res, l_order)
				end
			else
				handle_resource_not_found_response ("The following resource" + req.percent_encoded_path_info + " is not found ", req, res)
			end
		end

	is_conditional_get (req : WSF_REQUEST; l_order : ORDER) : BOOLEAN
			-- Check if If-None-Match is present and then if there is a representation that has that etag
			-- if the representation hasn't changed, we return TRUE
			-- then the response is a 304 with no entity body returned.
		local
			etag_util : ETAG_UTILS
		do
			if attached req.meta_string_variable ("HTTP_IF_NONE_MATCH") as if_none_match then
				create etag_util
				if if_none_match.same_string (etag_util.md5_digest (l_order.out).as_string_32) then
					Result := True
				end
			end
		end

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; l_order: ORDER)
		local
			l_msg : STRING
		do
			res.header.put_content_type_application_json
			if attached order_to_json (l_order) as jv then
				l_msg := jv.representation
				res.header.put_content_length (l_msg.count)
				res.header.put_utc_date (create {DATE_TIME}.make_now_utc)
				res.header.add_header ("etag:" + order_etag (l_order))
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_string (l_msg)
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Updating a resource with PUT
			-- A successful PUT request will not create a new resource, instead it will
			-- change the state of the resource identified by the current uri.
			-- If success we response with 200 and the updated order.
			-- 404 if the order is not found
			-- 400 in case of a bad request
			-- 500 internal server error
			-- If the request is a Conditional PUT, and it does not mat we response
			-- 415, precondition failed.
		do
			if attached order_id_from_request (req) as l_id then
				if has_order (l_id) then
					if attached order_from_request (req) as l_order then
						if l_order.has_id and then not l_id.same_string (l_order.id) then
								-- If request input data define an order id different from the one in request path!
							handle_resource_conflict_response ("ERROR: conflict between the url defining order id [" + l_id + "] and request data of order with id [" + l_order.id + "]!", req, res)
						else
							l_order.set_id (l_id)
							if is_valid_to_update (l_order) then
								if is_conditional_put (req, l_order) then
									update_order (l_order)
									compute_response_put (req, res, l_order)
								else
									handle_precondition_fail_response ("ERROR", req, res)
								end
							else
								--| TODO: build message explaining the conflict to the client!
								--| FIXME: Here we need to define the Allow methods
								handle_resource_conflict_response ("ERROR: order could not be updated!", req, res)
							end
						end
					else
						handle_bad_request_response ("ERROR: invalid request input data!", req, res)
					end
				else
					handle_bad_request_response ("ERROR: Order [" + l_id.out + "] was not found!", req, res)
				end
			else
				handle_bad_request_response ("ERROR: Missing ORDER id information!", req, res)
			end
		end

	is_conditional_put (req: WSF_REQUEST; a_order: ORDER): BOOLEAN
			-- Check if If-Match is present and then if `a_order` is matching that etag,
			-- if etag from `a_order` is unchanged, return True.
		do
			if attached req.meta_string_variable ("HTTP_IF_MATCH") as if_match then
				if attached order (a_order.id) as l_order then
					if if_match.same_string (order_etag (l_order)) then
						Result := True
					end
				else
					Result := False
				end
			else
				Result := True
			end
		end

	compute_response_put (req: WSF_REQUEST; res: WSF_RESPONSE; l_order : ORDER)
		do
			res.header.put_content_type_application_json
			res.header.put_utc_date (create {DATE_TIME}.make_now_utc)
			res.header.add_header ("etag:" + order_etag (l_order))
			if attached order_to_json (l_order) as jv then
				res.header.put_content_length (jv.representation.count)
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_string (jv.representation)
			end
		end

	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Here we use DELETE to cancel an order, if that order is in state where
			-- it can still be canceled.
			-- 200 if is ok
			-- 404 Resource not found
			-- 405 if consumer and service's view of the resouce state is inconsisent
			-- 500 if we have an internal server error
		do
			if
				attached order_id_from_request (req) as l_id and then
				attached order (l_id) as l_order
			then
				if is_valid_to_delete (l_order) then
					delete_order (l_order)
					compute_response_delete (req, res)
				else
					--| FIXME: Here we need to define the Allow methods
					handle_method_not_allowed_response (req.percent_encoded_path_info + "%N Conflict while trying to delete the order! The order could not be deleted in the current state!", req, res)
				end
			else
				handle_resource_not_found_response ("Order not found", req, res)
			end
		end

	compute_response_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			res.header.put_content_type_application_json
			res.header.put_utc_date (create {DATE_TIME}.make_now_utc)
			res.set_status_code ({HTTP_STATUS_CODE}.no_content)
		end

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Here the convention is the following.
			-- POST is used for creation and the server determines the URI
			-- of the created resource.
			-- If the request post is SUCCESS, the server will create the order and will response with
			-- HTTP_RESPONSE 201 CREATED, the Location header will contains the newly created order's URI
			-- if the request post is not SUCCESS, the server will response with
			-- HTTP_RESPONSE 400 BAD REQUEST, the client send a bad request
			-- HTTP_RESPONSE 500 INTERNAL_SERVER_ERROR, when the server can deliver the request
		do
			if attached order_from_request (req) as l_order then
				submit_order (l_order)
				compute_response_post (req, res, l_order)
			else
				handle_bad_request_response ("ERROR: invalid request input data!", req, res)
			end
		end

	compute_response_post (req: WSF_REQUEST; res: WSF_RESPONSE; l_order : ORDER)
		local
			l_msg : STRING
		do
			res.header.put_content_type_application_json
			if attached order_to_json (l_order) as jv then
				l_msg := jv.representation
				res.header.put_content_length (l_msg.count)
				res.header.put_location (req.absolute_script_url (req.request_uri + "/" + l_order.id))
				res.header.put_utc_date (create {DATE_TIME}.make_now_utc)
				res.set_status_code ({HTTP_STATUS_CODE}.created)
				res.put_string (l_msg)
			end
		end

feature {NONE} -- URI helper methods

	get_order_id_from_path (a_path: READABLE_STRING_32): READABLE_STRING_32
		do
			Result := a_path.split ('/').at (3)
		end

feature {NONE} -- Implementation Repository Layer

	order_etag (a_order: ORDER): STRING_8
		local
			etag_utils: ETAG_UTILS
		do
			create etag_utils
			Result := etag_utils.md5_digest (a_order.hash_code.out + a_order.revision.out)
		end

	is_valid_to_delete (a_order: ORDER): BOOLEAN
			-- Is the order identified by `a_id' in a state whre it can still be deleted?
		do
			if attached order (a_order.id) as l_order then
				if api.is_state_valid_to_update (l_order.status) then
					Result := True
				end
			end
		end

	is_valid_to_update (a_order: ORDER): BOOLEAN
			-- Check if there is a conflict while trying to update the order.
		do
		   	if attached order (a_order.id) as l_existing_order then
				if
					api.is_state_valid_to_update (l_existing_order.status) and then
					api.is_valid_status_state (a_order.status) and then
					api.is_valid_transition (l_existing_order, a_order.status)
				then
				 	Result := True
				end
			end
		end

	order_from_request (req: WSF_REQUEST): detachable ORDER
			-- extract an object Order from the request,
			-- or Void if the request is invalid.
		local
			l_data: STRING
		do
			create l_data.make (req.content_length_value.to_integer_32)
			req.read_input_data_into (l_data)

			Result := order_from_request_input_data (l_data)
		end

	order_from_request_input_data (a_data: READABLE_STRING_8): detachable ORDER
			-- extract an object Order from the request,
			-- or Void if the request is invalid.
		local
			parser : JSON_PARSER
		do
			create parser.make_with_string (a_data)
			parser.parse_content
			if
				parser.is_valid and then
				attached parser.parsed_json_value as jv
			then
				Result := order_from_json (jv)
			end
		end

feature {NONE} -- Conversion

	order_to_json (obj: ORDER): JSON_VALUE
		do
			Result := order_serialization.to_json (obj)
		end

	order_from_json (jv: JSON_VALUE): detachable ORDER
		do
			if attached {ORDER} order_serialization.from_json (jv, {ORDER}) as o then
				Result := o
			end
		end

	order_serialization: JSON_SERIALIZATION
		do
			create Result
			Result.register (create {ORDER_JSON_SERIALIZATION}, {ORDER})
		end

note
	copyright: "2011-2017, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
