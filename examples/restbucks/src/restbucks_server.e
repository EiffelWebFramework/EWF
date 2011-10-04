note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	RESTBUCKS_SERVER

inherit
	ANY

	URI_TEMPLATE_ROUTED_APPLICATION

	ROUTED_APPLICATION_HELPER

	DEFAULT_WGI_APPLICATION

	WGI_RESPONSE_STATUS_CODES


create
	make

feature {NONE} -- Initialization


	make
		do
			initialize_router
			make_and_launch
		end

	create_router
		do
			create router.make (5)
		end

	setup_router
		local
			order_handler: ORDER_HANDLER [REQUEST_URI_TEMPLATE_HANDLER_CONTEXT]
		do
			create order_handler
			router.map_with_request_methods ("/order", order_handler, <<"POST">>)
			router.map_with_request_methods ("/order/{orderid}", order_handler, <<"GET", "DELETE", "PUT">>)
		end

feature -- Execution

	execute_default (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		-- I'm using this method to handle the method not allowed response
		-- in the case that the given uri does not have a corresponding http method
		-- to handle it.

		local
			h : EWF_HEADER
			l_description : STRING
			l_api_doc : STRING
		do
					if  req.content_length_value > 0 then
						req.input.read_stream (req.content_length_value.as_integer_32)
					end
					create h.make
					h.put_status (method_not_allowed)
					h.put_content_type ("application/json")
					l_api_doc := "%NPlease check the API%NURI:/order METHOD: POST%NURI:/order/{orderid} METHOD: GET, PUT, DELETE%N"
					l_description := req.request_method + req.request_uri + " is not allowed" + "%N" + l_api_doc
					h.put_content_length (l_description.count)
					h.add_header ("Date:"+ ((create{HTTP_DATE_TIME_UTILITIES}).now_utc).formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
					res.set_status_code (method_not_allowed)
					res.write_headers_string (h.string)
					res.write_string (l_description)
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
