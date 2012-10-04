note
	description : "Filter example."
	author      : "Olivier Ligot"
	date        : "$Date$"
	revision    : "$Revision$"

class
	FILTER_SERVER

inherit
	ANY

	WSF_FILTERED_SERVICE

	WSF_HANDLER_HELPER

	WSF_DEFAULT_SERVICE

	SHARED_EJSON

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize_filter
			initialize_json
			set_service_option ("port", 9090)
			make_and_launch
		end

	create_filter
			-- Create `filter'
		local
			l_router: WSF_ROUTER
			l_authentication_filter_hdl: AUTHENTICATION_FILTER
			l_user_filter: USER_HANDLER
			l_routing_filter: WSF_ROUTING_FILTER
		do
			create l_router.make (1)
			create l_authentication_filter_hdl
			create l_user_filter
			l_authentication_filter_hdl.set_next (l_user_filter)

			l_router.handle_with_request_methods ("/user/{userid}", l_authentication_filter_hdl, l_router.methods_get)
			create l_routing_filter.make (l_router)
			l_routing_filter.set_execute_default_action (agent execute_default)
			filter := l_routing_filter
		end

	setup_filter
			-- Setup `filter'
		local
			l_logging_filter: LOGGING_FILTER
		do
			create l_logging_filter
			filter.set_next (l_logging_filter)
		end

	initialize_json
			-- Initialize `json'.
		do
			json.add_converter (create {JSON_USER_CONVERTER}.make)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			filter.execute (req, res)
		end

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
			l_api_doc := "%NPlease check the API%NURI:/user/{userid} METHOD: GET%N"
			l_description := req.request_method + req.request_uri + " is not allowed" + "%N" + l_api_doc
			h.put_content_length (l_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			res.put_header_text (h.string)
			res.put_string (l_description)
		end

note
	copyright: "2011-2012, Olivier Ligot, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
