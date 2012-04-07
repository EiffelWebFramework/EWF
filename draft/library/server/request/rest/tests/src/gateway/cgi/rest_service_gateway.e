deferred class
	REST_SERVICE_GATEWAY

inherit
	WSF_SERVICE

feature -- Access

	build_gateway_and_launch
		local
			cgi: WGI_CGI_CONNECTOR
		do
			create cgi.make (to_wgi_service)
			cgi.launch
		end

	gateway_name: STRING = "CGI"

	exit_with_code (a_code: INTEGER)
		do
			(create {EXCEPTIONS}).die (a_code)
		end

end
