note
	description : "REST Buck server"
	date        : "$Date$"
	revision    : "$Revision$"

class
	RESTBUCKS_SERVER

inherit
	ANY

	WSF_URI_TEMPLATE_ROUTED_SERVICE

	WSF_HANDLER_HELPER

	WSF_DEFAULT_SERVICE

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize_router
			set_service_option ("port", 9090)
			make_and_launch
		end

	setup_router
		local
			order_handler: ORDER_HANDLER
		do
			create order_handler
			router.handle_with_request_methods ("/order", order_handler, router.methods_POST)
			router.handle_with_request_methods ("/order/{orderid}", order_handler, router.methods_GET + router.methods_DELETE + router.methods_PUT)
		end

feature -- Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- I'm using this method to handle the method not allowed response
			-- in the case that the given uri does not have a corresponding http method
			-- to handle it.
		local
			h : HTTP_HEADER
			l_description : STRING
			l_api_doc : STRING
		do
			if req.content_length_value > 0 then
				req.input.read_string (req.content_length_value.as_integer_32)
			end
			create h.make
			h.put_content_type_text_plain
			l_api_doc := "%NPlease check the API%NURI:/order METHOD: POST%NURI:/order/{orderid} METHOD: GET, PUT, DELETE%N"
			l_description := req.request_method + req.request_uri + " is not allowed" + "%N" + l_api_doc
			h.put_content_length (l_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			res.put_header_text (h.string)
			res.put_string (l_description)
		end

note
	copyright: "2011-2012, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
