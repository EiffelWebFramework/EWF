note
	description: "Summary description for {APPLICATION_EXECUTION}."
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
			append_filters (<<create {WSF_LOGGING_FILTER}>>)
		end

	setup_router
		do
			map_agent_uri ("/", agent execute_hello, Void)
			map_agent_uri ("/grid", agent grid_demo, Void)
			map_agent_uri ("/repeater", agent repeater_demo, Void)
			map_agent_uri ("/slider", agent slider_demo, Void)
			map_agent_uri ("/upload", agent upload_demo, Void)
			map_agent_uri ("/codeview", agent codeview, Void)

				-- NOTE: you could put all those files in a specific folder, and use WSF_FILE_SYSTEM_HANDLER with "/"
				-- this way, it handles the caching and so on
			router.handle ("/assets", create {WSF_FILE_SYSTEM_HANDLER}.make_hidden ("assets"), router.methods_GET)
		end

feature -- Helper: mapping

	map_agent_uri (a_uri: READABLE_STRING_8; a_action: like {WSF_URI_AGENT_HANDLER}.action; rqst_methods: detachable WSF_REQUEST_METHODS)
		do
			router.map (create {WSF_URI_MAPPING}.make (a_uri, create {WSF_URI_AGENT_HANDLER}.make (a_action)), rqst_methods)
		end

feature -- Execution

	execute_hello (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			page: SAMPLE_PAGE
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			create page.make (req, res)
			page.execute
		end

	grid_demo (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			page: GRID_PAGE
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			create page.make (req, res)
			page.execute
		end

	repeater_demo (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			page: REPEATER_PAGE
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			create page.make (req, res)
			page.execute
		end

	slider_demo (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			page: SLIDER_PAGE
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			create page.make (req, res)
			page.execute
		end

	upload_demo (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			page: UPLOAD_PAGE
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			create page.make (req, res)
			page.execute
		end

	codeview (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			page: CODEVIEW_PAGE
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			create page.make (req, res)
			page.execute
		end

end
