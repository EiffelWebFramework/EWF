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
			l_authentication_filter_hdl: AUTHENTICATION_FILTER
			l_user_filter: USER_HANDLER
			l_routing_filter: WSF_ROUTING_FILTER
		do
			create router.make (1)
			create l_authentication_filter_hdl
			create l_user_filter
			l_authentication_filter_hdl.set_next (l_user_filter)

			router.handle_with_request_methods ("/user/{userid}", l_authentication_filter_hdl, router.methods_get)
			create l_routing_filter.make (router)
			l_routing_filter.set_execute_default_action (agent execute_default)
			filter := l_routing_filter
		end

	setup_filter
			-- Setup `filter'
		local
			l_logging_filter: WSF_LOGGING_FILTER
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
		local
			l_message: WSF_DEFAULT_ROUTER_RESPONSE
		do
			create l_message.make_with_router (req, router)
			l_message.set_documentation_included (True)
			res.send (l_message)
		end

feature {NONE} -- Implementation

	router: WSF_ROUTER;
			-- Router

note
	copyright: "2011-2013, Olivier Ligot, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
