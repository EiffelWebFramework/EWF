note
	description: "simple application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_EXECUTION

inherit

	WSF_FILTERED_ROUTED_EXECUTION

create
	make

feature -- Router and Filter

	create_filter
			-- Create `filter'
		do
				-- Maintenance
			create {WSF_MAINTENANCE_FILTER} filter
		end

	setup_filter
			-- Setup `filter'
		do
			append_filters (<< create {WSF_LOGGING_FILTER} >>)
		end

	setup_router
		do
			map_agent_uri ("/", agent execute_hello, Void)
				-- NOTE: you could put all those files in a specific folder, and use WSF_FILE_SYSTEM_HANDLER with "/"
				-- this way, it handles the caching and so on
			router.handle_with_request_methods ("/assets", create {WSF_FILE_SYSTEM_HANDLER}.make_hidden ("assets"), router.methods_GET)
		end

feature -- Helper: mapping

	map_agent_uri (a_uri: READABLE_STRING_8; a_action: like {WSF_URI_AGENT_HANDLER}.action; rqst_methods: detachable WSF_REQUEST_METHODS)
		do
			router.map_with_request_methods (create {WSF_URI_MAPPING}.make (a_uri, create {WSF_URI_AGENT_HANDLER}.make (a_action)), rqst_methods)
		end


feature -- Execution

	execute_hello (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			page: EMPTY_PAGE
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			create page.make (req, res)
			page.execute
		end


end
