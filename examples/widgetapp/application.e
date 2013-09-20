note
	description: "simple application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	WSF_ROUTED_SERVICE
		rename
			execute as execute_router
		end

	WSF_FILTERED_SERVICE

	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

	WSF_FILTER
		rename
			execute as execute_router
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			initialize_router
			initialize_filter
			Precursor
			set_service_option ("port", 9090)
		end

feature -- Router and Filter

	create_filter
			-- Create `filter'
		local
			f, l_filter: detachable WSF_FILTER
		do
			l_filter := Void

				-- Maintenance
			create {WSF_MAINTENANCE_FILTER} f
			f.set_next (l_filter)
			l_filter := f

				-- Logging
			create {WSF_LOGGING_FILTER} f
			f.set_next (l_filter)
			l_filter := f

			filter := l_filter
		end

	setup_filter
			-- Setup `filter'
		local
			f: WSF_FILTER
		do
			from
				f := filter
			until
				not attached f.next as l_next
			loop
				f := l_next
			end
			f.set_next (Current)
		end

	setup_router
		do
				--			router.map (create {WSF_URI_MAPPING}.make ("/hello", create {WSF_AGENT_URI_HANDLER}.make (agent execute_hello)))
			map_agent_uri ("/", agent execute_hello, Void)
			map_agent_uri ("/grid", agent grid_demo, Void)
			map_agent_uri ("/repeater", agent repeater_demo, Void)

				-- NOTE: you could put all those files in a specific folder, and use WSF_FILE_SYSTEM_HANDLER with "/"
				-- this way, it handles the caching and so on
			map_agent_uri ("/widget.js", agent load_file("widget.js", ?, ?), Void)
			map_agent_uri ("/jquery.min.js", agent load_file("jquery.min.js", ?, ?), Void)
			map_agent_uri ("/typeahead.min.js", agent load_file("typeahead.min.js", ?, ?), Void)
			map_agent_uri ("/widget.css", agent load_file("widget.css", ?, ?), Void)
			map_agent_uri ("/bootstrap.min.css", agent load_file("bootstrap.min.css", ?, ?), Void)
		end

feature -- Helper: mapping

	map_agent_uri (a_uri: READABLE_STRING_8; a_action: like {WSF_URI_AGENT_HANDLER}.action; rqst_methods: detachable WSF_REQUEST_METHODS)
		do
			router.map_with_request_methods (create {WSF_URI_MAPPING}.make (a_uri, create {WSF_URI_AGENT_HANDLER}.make (a_action)), rqst_methods)
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

	load_file (name: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			f: WSF_FILE_RESPONSE
		do
			create f.make_html (name)
			res.send (f)
		end

end
