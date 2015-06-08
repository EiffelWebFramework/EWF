note
	description : "Basic Service that build a generic front end for the most used search engines."
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
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
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			l_message: STRING
		do
				-- (1) To send a response we need to setup, the status code and the response headers.
--			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
--			res.put_string (web_page)

				-- (2) Using put_header_line
--			res.set_status_code ({HTTP_STATUS_CODE}.ok)
--			res.put_header_line ("Content-Type:text/html")
			res.put_header_line ("Content-Length:"+ web_page.count.out)
			res.put_header_line ("Content-Type:text/plain")

			res.put_string (web_page)
		end



feature -- Home Page

	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>EWF Headers Responses</title>
		</head>
		<body>
			<div class="right">
				<h2>Example Header Response</h2>	
				<p>Response headers</p>
				
			</div>
			<div id="footer">
				<p>EWF Response Header</p>
			</div>
		</body>
	</html>
]"
end
