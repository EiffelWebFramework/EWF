note
	description : "Basic Service that build a generic front end for the most used search engines."
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute
			-- Execute the incomming request
		local
			l_message: STRING
		do
				-- (1) To send a response we need to setup, the status code and the response headers.
--			response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
--			response.put_string (web_page)

				-- (2) Using put_header_line
--			response.set_status_code ({HTTP_STATUS_CODE}.ok)
--			response.put_header_line ("Content-Type:text/html")
			response.put_header_line ("Content-Length:"+ web_page.count.out)
			response.put_header_line ("Content-Type:text/plain")

			response.put_string (web_page)
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
