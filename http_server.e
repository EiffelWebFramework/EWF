note
	description: "Summary description for {HTTP_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_SERVER
inherit
	SHARED_DOCUMENT_ROOT
create
	make
feature -- Initialization
	make
		do

		end

	setup
		local
			l_http_handler : HTTP_CONNECTION_HANDLER
		do
			print("%N%N%N")
			print ("Starting Web Application Server:%N")
			stop := False
			document_root_cell.put (document_root)
			create l_http_handler.make (current,"HTTP_HANDLER")
			l_http_handler.launch
			run
		end

	shutdown_server
		do
			stop := True
		end

feature	-- Access
	stop: BOOLEAN
		-- Stops the server

	document_root: STRING = "./webroot"

feature {NONE} -- implementation

	run
		-- Start the server
		local
			l_thread: EXECUTION_ENVIRONMENT
		do
			create l_thread
			from until stop	loop
				l_thread.sleep (1000000)
			end

		end
end
