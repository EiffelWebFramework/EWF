note
	description : "nino application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_server : HTTP_SERVER
			l_cfg: HTTP_SERVER_CONFIGURATION
			l_http_handler : HTTP_HANDLER
		do
			create l_cfg.make
			l_cfg.http_server_port := 9_000
			l_cfg.document_root := default_document_root

			create l_server.make (l_cfg)
			create {APPLICATION_CONNECTION_HANDLER} l_http_handler.make (l_server, "HTTP_HANDLER")
			l_server.setup (l_http_handler)
		end

feature -- Access

	default_document_root: STRING = "webroot"

end
