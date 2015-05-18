note
	description : "Basic Service that a simple web page to show the most common status codes"
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
				-- To send a response we need to setup, the status code and
				-- the response headers.
			if req.is_get_request_method then
				if req.path_info.same_string ("/") then
					res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
					res.put_string (web_page)
				elseif req.path_info.same_string ("/redirect") then
					send_redirect (req, res, "https://httpwg.github.io/")
				elseif req.path_info.same_string ("/bad_request") then
					 	-- Here you can do some logic for example log, send emails to register the error, before to send the response.
					create l_message.make_from_string (message_template)
					l_message.replace_substring_all ("$title", "Bad Request")
					l_message.replace_substring_all ("$status", "Bad Request 400")
					res.put_header ({HTTP_STATUS_CODE}.bad_request, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
					res.put_string (l_message)
				elseif req.path_info.same_string ("/internal_error") then
						 	-- Here you can do some logic for example log, send emails to register the error, before to send the response.
			   		create l_message.make_from_string (message_template)
					l_message.replace_substring_all ("$title", "Internal Server Error")
					l_message.replace_substring_all ("$status", "Internal Server Error 500")
					res.put_header ({HTTP_STATUS_CODE}.internal_server_error, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
					res.put_string (l_message)
			   	else
			   		create l_message.make_from_string (message_template)
					l_message.replace_substring_all ("$title", "Resource not found")
					l_message.replace_substring_all ("$status", "Resource not found 400")
					res.put_header ({HTTP_STATUS_CODE}.not_found, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
					res.put_string (l_message)
			   	end
			else
				create l_message.make_from_string (message_template)
				l_message.replace_substring_all ("$title", "Method Not Allowed")
				l_message.replace_substring_all ("$status", "Method Not Allowed 405")
					-- Method not allowed
				res.put_header ({HTTP_STATUS_CODE}.method_not_allowed, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
				res.put_string (l_message)
			end
		end


feature -- Home Page

	send_redirect (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: READABLE_STRING_32)
			-- Redirect to `a_location'
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			h.put_location (a_location)
			res.set_status_code ({HTTP_STATUS_CODE}.see_other)
			res.put_header_text (h.string)
		end

	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>Example showing common status codes</title>
		</head>
		<body>
			<div id="header">
				<p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
			</div>
			<div class="left"></div>
			<div class="right">
				<h4>This page is an example of Status Code 200</h4>

				<h4> Redirect Example </h4>
				<p> Click on the following link will redirect you to the HTTP Specifcation, we can do the redirect from the HTML directly but
				here we want to show you an exmaple, where you can do something before to send a redirect <a href="/redirect">Redirect</a></p>

				<h4> Bad Request </h4>
				<p> Click on the following link, the server will answer with a 400 error, check the status code <a href="/bad_request">Bad Request</a></p>

				<h4> Internal Server Error </h4>
				<p> Click on the following link, the server will answer with a 500 error, check the status code <a href="/internal_error">Internal Error</a></p>
				
				<h4> Resource not found </h4>
				<p> Click on the following link or add to the end of the url something like /1030303 the server will answer with a 404 error, check the status code <a href="/not_foundd">Not found</a></p>

			</div>
			<div id="footer">
				<p>Useful links for status codes <a href="httpstat.us">httpstat.us</a> and <a href="httpbing.org">httpbin.org</a></p>
			</div>
		</body>
	</html>
]"

feature -- Generic Message

	message_template: STRING="[
	<!DOCTYPE html>
	<html>
		<head>
			<title>$title</title>
		</head>
		<body>
			<div id="header">
				<p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
			</div>
			<div class="left"></div>
			<div class="right">
				<h4>This page is an example of $status</h4>
			
			<div id="footer">
				<p><a href="/">Back Home</a></p>
			</div>
		</body>
	</html>
]"




end
