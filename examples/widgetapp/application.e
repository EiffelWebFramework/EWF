note
	description: "simple application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	WSF_ROUTED_SERVICE

	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			initialize_router
			set_service_option ("port", 9090)
		end

feature {NONE} -- Initialization

	setup_router
		do
				--			router.map (create {WSF_URI_MAPPING}.make ("/hello", create {WSF_AGENT_URI_HANDLER}.make (agent execute_hello)))
			map_agent_uri ("/", agent execute_hello, Void)
			map_agent_uri ("/grid", agent grid_demo, Void)
			map_agent_uri ("/widget.js", agent load_js, Void)
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

	load_js (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			f: WSF_FILE_RESPONSE
		do
			create f.make_html ("widget.js")
			res.send (f)
		end

end
