note
	description: "Summary description for {HTTP_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_SERVER

inherit
	HTTP_SERVER_SHARED_CONFIGURATION

create
	make

feature -- Initialization

	make (cfg: like configuration)
		do
			configuration := cfg
		end

	setup (a_http_handler : HTTP_HANDLER)
		require
			a_http_handler_valid: a_http_handler /= Void
		do
			print("%N%N%N")
			print ("Starting Web Application Server (port="+ configuration.http_server_port.out +"):%N")
			stop_requested := False
			set_server_configuration (configuration)
			if configuration.force_single_threaded then
				a_http_handler.execute
			else
				a_http_handler.launch
				a_http_handler.join
			end
		end

	shutdown_server
		do
			stop_requested := True
		end

feature	-- Access

	configuration: HTTP_SERVER_CONFIGURATION
			-- Configuration of the server

	stop_requested: BOOLEAN
			-- Stops the server

feature {NONE} -- implementation

	run
		-- Start the server
		local
			e: EXECUTION_ENVIRONMENT
		do
			create e
			from until stop_requested loop
				e.sleep (1_000_000)
			end
		end

end
