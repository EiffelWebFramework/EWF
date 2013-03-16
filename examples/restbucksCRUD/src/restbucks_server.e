note
	description : "REST Buck server"
	date        : "$Date$"
	revision    : "$Revision$"

class RESTBUCKS_SERVER

inherit

	WSF_SKELETON_SERVER
		redefine
			execute_default
		end

	WSF_DEFAULT_SERVICE

	WSF_HANDLER_HELPER

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
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
		do
			create order_handler
			router.handle_with_request_methods ("/order", order_handler, router.methods_POST)
			router.handle_with_request_methods ("/order/{orderid}", order_handler, router.methods_GET + router.methods_DELETE + router.methods_PUT)
			create doc.make_hidden (router)
			router.handle_with_request_methods ("/api/doc", doc, router.methods_GET)
		end

feature -- Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- I'm using this method to handle the method not allowed response
			-- in the case that the given uri does not have a corresponding http method
			-- to handle it.
		do
			Precursor (req, res)
		end

note
	copyright: "2011-2013, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
