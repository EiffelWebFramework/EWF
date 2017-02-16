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
				-- To send a response we need to setup, the status code and
				-- the response headers.
			if request.is_get_request_method then
				if request.path_info.same_string ("/") then
					response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
					response.put_string (web_page)
				else
			   		send_resouce_not_found (request, response)
			   	end
			elseif request.is_post_request_method then
				if request.path_info.same_string ("/search") then
					if attached {WSF_STRING} request.form_parameter ("query") as l_query then
						if	attached {WSF_STRING} request.form_parameter ("engine") as l_engine then
						    if attached {STRING} map.at (l_engine.value) as l_engine_url then
						    	l_engine_url.append (l_query.value)
						   		send_redirect (request, response, l_engine_url)
						   		-- response.redirect_now (l_engine_url)
						   	else
						   	  	send_bad_request (request, response, " <strong>search engine: " + l_engine.value + "</strong> not supported,<br> try with Google or Bing")
						   	end
						else
							send_bad_request (request, response, " <strong>search engine</strong> not selected")
						end
					else
						send_bad_request (request, response, " form_parameter <strong>query</strong> is not present")
				   	end
				else
					send_resouce_not_found (request, response)
				end
			else
				create l_message.make_from_string (message_template)
				l_message.replace_substring_all ("$title", "Method Not Allowed")
				l_message.replace_substring_all ("$status", "Method Not Allowed 405")
					-- Method not allowed
				response.put_header ({HTTP_STATUS_CODE}.method_not_allowed, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
				response.put_string (l_message)
			end
		end


feature -- Engine Map

	map : STRING_TABLE[STRING]
		do
			create Result.make (2)
			Result.put ("http://www.google.com/search?q=", "Google")
			Result.put ("http://www.bing.com/search?q=", "Bing")
		end

feature -- Redirect

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

feature -- Bad Request

	send_bad_request (req: WSF_REQUEST; res: WSF_RESPONSE; description: STRING)
		local
			l_message: STRING
		do
			create l_message.make_from_string (message_template)
			l_message.replace_substring_all ("$title", "Bad Request")
			l_message.replace_substring_all ("$status", "Bad Request" + description)
			res.put_header ({HTTP_STATUS_CODE}.bad_request, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
			res.put_string (l_message)
		end

feature -- Resource not found

	send_resouce_not_found (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_message: STRING
		do
			create l_message.make_from_string (message_template)
			l_message.replace_substring_all ("$title", "Resource not found")
			l_message.replace_substring_all ("$status", "Resource " + req.request_uri + " not found 404")
			res.put_header ({HTTP_STATUS_CODE}.not_found, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
			res.put_string (l_message)
		end

feature -- Home Page

	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>Generic Search Engine</title>
		</head>
		<body>
			<div class="right">
				<h2>Generic Search Engine</h2>	
				<form method="POST" action="/search" target="_blank">
				   <fieldset>	
				 	 Search: <input type="search" name="query" placeholder="EWF framework"><br>
				   	<div>
					   	<input type="radio" name="engine" value="Google" checked><img src="http://ebizmba.ebizmbainc.netdna-cdn.com/images/logos/google.gif" height="24" width="42"> 
                    </div>
				
				   	<div>
				   			<input type="radio" name="engine" value="Bing"><img src="http://ebizmba.ebizmbainc.netdna-cdn.com/images/logos/bing.gif" height="24" width="42">
				   	</div><br>		
				   </fieldset>
				   <input type="submit">
				</form>


			</div>
			<div id="footer">
				<p><a href="http://www.ebizmba.com/articles/search-engines">Top 15 Most Popular Search Engines | March 2015</a></p>
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
