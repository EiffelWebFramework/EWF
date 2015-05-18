
Nav: [Workbook](../workbook.md) | [Handling Requests: Header Fields](/workbook/handling_request/headers.md) | [Handling Cookies](/workbook/handling_cookies/handling_cookies.md) 


## EWF Generating Response

##### Table of Contents  
- [Format of the HTTP response](#format)  
- [How to set status code](#status_set)  
- [How to redirect to a particular location.](#redirect)  
- [HTTP Status codes](#status)
- [Example Staus Codes](#example_1)
- [Generic Search Engine](#example_2)
- [Response Header Fields](#header_fields)


<a name="format"/>
## Format of the HTTP response

As we saw in the previous documents, a request from a user-agent (browser or other client) consists of an HTTP command (usually GET or POST), zero or more request headers (one or more in HTTP 1.1, since Host is required), a blank line, and only in the case of POST/PUT requests, payload data. A typical request looks like the following.

```
	GET /url[query_string] HTTP/1.1
	Host: ...
	Header2: ...
	...
	HeaderN:
	(Blank Line)
```

When a Web server responds to a request, the response typically consists of a status line, some response headers, a blank line, and the document. A typical response
looks like this:

```
	HTTP/1.1 200 OK
	Content-Type: text/html
	Header2: ...
	...
	HeaderN: ...
	(Blank Line)
	<!DOCTYPE ...>
	<HTML>
		<HEAD>...</HEAD>
		<BODY>
		...
		</BODY>
	</HTML>
```

The status line consists of the HTTP version (HTTP/1.1 in the preceding example), a status code (an integer 200 in the example), and a very short message corresponding to the status code (OK in the example). In most cases, the headers are optional except for Content-Type, which specifies the MIME type of the document that follows. Although most responses contain a document, some don’t. For example, responses to HEAD requests should never include a document, and various status codes essentially indicate failure or redirection (and thus either don’t include a document or include only a short error-message document).

<a name="status_set"/>
## How to set the status code

If you need to set an arbitrary status code, you can use the ```WSF_RESPONSE.put_header``` feature  or the ```WSF_RESPONSE.set_status_code``` feature. An status code of 200 is a default value.  See below examples using the mentioned features.

### Using the WSF_RESPONSE.put_header feature.
In this case you provide the status code with a collection of headers. 

```eiffel
	put_header (a_status_code: INTEGER_32; a_headers: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Put headers with status `a_status', and headers from `a_headers'
		require
			a_status_code_valid: a_status_code > 0
			status_not_committed: not status_committed
			header_not_committed: not header_committed
		ensure
			status_code_set: status_code = a_status_code
			status_set: status_is_set
			message_writable: message_writable

Example			
	res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", output_size]>>) 
	res.put_string (web_page)
```

### Using the WSF_RESPONSE.set_status code

```eiffel
	custom_response (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_text_html
			h.put_content_length (l_msg.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end
```
Both features takes an INTEGER (the status code) as an formal argument, you can use 200, 300, 500 etc directly, but instead of using explicit numbers, it's recommended to use the constants defined in the class [HTTP_STATUS_CODE](). The name of each constant is based from the standard [HTTP 1.1](https://httpwg.github.io/).

<a name="redirect"/>
## How to redirect to a particular location.
To redirect the response to a new location, we need to send a 302 status code, to do that we use ```{HTTP_STATUS_CODE}.found```

> The 302 (Found) status code indicates that the target resource resides temporarily under a different URI. Since the redirection might be altered on occasion, the client ought to continue to use the effective request URI for future requests.

Another way to do redirection is with 303 status code

> The 303 (See Other) status code indicates that the server is redirecting the user agent to a different resource, as indicated by a URI in the Location header field, which is intended to provide an indirect response to the original request. 

The next code show a custom feature to write a redirection, you can use found or see_other based on your particular requirements.

```eiffel
	send_redirect (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: READABLE_STRING_32)
			-- Redirect to `a_location'
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			h.put_location (a_location)
			res.set_status_code ({HTTP_STATUS_CODE}.found)
			res.put_header_text (h.string)
		end
```

The class [WSF_RESPONSE]() provide features to work with redirection 

```eiffel
	redirect_now (a_url: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		require
			header_not_committed: not header_committed

	redirect_now_custom (a_url: READABLE_STRING_8; a_status_code: INTEGER_32; a_header: detachable HTTP_HEADER; a_content: detachable TUPLE [body: READABLE_STRING_8; type: READABLE_STRING_8])
			-- Redirect to the given url `a_url' and precise custom `a_status_code', custom header and content
			-- Please see http://www.faqs.org/rfcs/rfc2616 to use proper status code.
			-- if `a_status_code' is 0, use the default {HTTP_STATUS_CODE}.temp_redirect
		require
			header_not_committed: not header_committed

	redirect_now_with_content (a_url: READABLE_STRING_8; a_content: READABLE_STRING_8; a_content_type: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
```

The ```WSF_RESPONSE.redirect_now``` feature use the status code ```{HTTP_STATUS_CODE}.found```,the other redirect features enable customize the status code and content based on your requirements.


Using a similar approach we can build features to answer a bad request (400), internal server error (500), etc. We will build a simple example showing the most common HTTP status codes.

<a name="status"/>
## [HTTP 1.1 Status Codes](https://httpwg.github.io/specs/rfc7231.html#status.codes)
The status-code element is a three-digit integer code giving the result of the attempt to understand and satisfy the request. The first digit of the status-code defines the class of response. 

General categories:
* [1xx](https://httpwg.github.io/specs/rfc7231.html#status.1xx) Informational: The 1xx series of response codes are used only in negotiations with the HTTP server.
* [2xx](https://httpwg.github.io/specs/rfc7231.html#status.2xx) Sucessful: The 2xx error codes indicate that an operation was successful.
* [3xx](https://httpwg.github.io/specs/rfc7231.html#status.3xx) Redirection: The 3xx status codes indicate that the client needs to do some extra work to get what it wants.
* [4xx](https://httpwg.github.io/specs/rfc7231.html#status.4xx) Client Error: These status codes indicate that something is wrong on the client side. 
* [5xx](https://httpwg.github.io/specs/rfc7231.html#status.5xx) Server Error: These status codes indicate that something is wrong on the server side. 

Note: use ```res.set_status_code({HTTP_STATUS_CODE}.bad_request)``` rather than ```res.set_status_code(400)```.


<a name="example_1"/>
### Example Staus Codes
Basic Service that builds a simple web page to show the most common status codes
```eiffel
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
					-- res.redirect_now (l_engine_url)
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

```



<a name="example_2"/>
### Example Generic Search Engine
The following example shows a basic EWF service that builds a generic front end for the most used search engines. This example shows how
redirection works, and we will use a tools to play with the API to show differents responses.

```eiffel
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
				-- To send a response we need to setup, the status code and
				-- the response headers.
			if req.is_get_request_method then
				if req.path_info.same_string ("/") then
					res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
					res.put_string (web_page)
				else
			   		send_resouce_not_found (req, res)
			   	end
			elseif req.is_post_request_method then
				if req.path_info.same_string ("/search") then
					if attached {WSF_STRING} req.form_parameter ("query") as l_query then
						if	attached {WSF_STRING} req.form_parameter ("engine") as l_engine then
						    if attached {STRING} map.at (l_engine.value) as l_engine_url then
						    	l_engine_url.append (l_query.value)
						   		send_redirect (req, res, l_engine_url)
						   	else
						   	  	send_bad_request (req, res, " <strong>search engine: " + l_engine.value + "</strong> not supported,<br> try with Google or Bing")
						   	end
						else
							send_bad_request (req, res, " <strong>search engine</strong> not selected")
						end
					else
						send_bad_request (req, res, " form_parameter <strong>query</strong> is not present")
				   	end
				else
					send_resouce_not_found (req, res)
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
			l_message.replace_substring_all ("$status", "Resource" + req.request_uri + "not found 404")
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

```

Using cURL to test the application

In the first call we use the ```res.redirect_now (l_engine_url)``` feature
```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Google" http://localhost:9090/search
HTTP/1.1 302 Found
Location: http://www.google.com/search?q=Eiffel
Content-Length: 0
Connection: close
```

Here we use our custom send_redirect feature call.

```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Google" http://localhost:9090/search
HTTP/1.1 303 See Other
Content-Type: text/html
Date: Fri, 06 Mar 2015 14:37:33 GMT
Location: http://www.google.com/search?q=Eiffel
Connection: close
```

#### Engine Ask Not supported

```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Ask" http://localhost:9090/search
HTTP/1.1 400 Bad Request
Content-Type: text/html
Content-Length: 503
Connection: close

<!DOCTYPE html>
<html>
        <head>
                <title>Bad Request</title>
        </head>
        <body>
                <div id="header">
                        <p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
                </div>
                <div class="left"></div>
                <div class="right">
                        <h4>This page is an example of Bad Request <strong>search engine: Ask</strong> not supported,<br> try with Google or Bing</h4>

                <div id="footer">
                        <p><a href="/">Back Home</a></p>
                </div>
        </body>
</html>
```


#### Missing query form parameter

```
#>curl -i -H -v -X POST -d "engine=Google" http://localhost:9090/search
HTTP/1.1 400 Bad Request
Content-Type: text/html
Content-Length: 477
Connection: close

<!DOCTYPE html>
<html>
        <head>
                <title>Bad Request</title>
        </head>
        <body>
                <div id="header">
                        <p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
                </div>
                <div class="left"></div>
                <div class="right">
                        <h4>This page is an example of Bad Request form_parameter <strong>query</strong> is not present</h4>

                <div id="footer">
                        <p><a href="/">Back Home</a></p>
                </div>
        </body>
</html>
```

#### Resource searchs not found

```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Google" http://localhost:9090/searchs
HTTP/1.1 404 Not Found
Content-Type: text/html
Content-Length: 449
Connection: close

<!DOCTYPE html>
<html>
        <head>
                <title>Resource not found</title>
        </head>
        <body>
                <div id="header">
                        <p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
                </div>
                <div class="left"></div>
                <div class="right">
                        <h4>This page is an example of Resource /searchs not found 404</h4>

                <div id="footer">
                        <p><a href="/">Back Home</a></p>
                </div>
        </body>
</html>
```

<a name="header_fields"/>
## [Response Header Fields](https://httpwg.github.io/specs/rfc7231.html#response.header.fields)

The response header fields allow the server to pass additional information about the response beyond what is placed in the status-line. These header fields give information about the server, about further access to the target resource, or about related resources. We can specify cookies, page modification date (for caching), reload a page after a designated period of time, size of the document.



### How to set response headers.

HTTP allows multiple occurrences of the same header name, the features  ```put_XYZ``` replace existing headers with the same name and
features ```add_XYZ``` add headers that can lead to duplicated entries.


```eiffel
	add_header_line (h: READABLE_STRING_8)
			-- Add header `h'
			-- This can lead to duplicated header entries
		require
			header_not_committed: not header_committed

	add_header_text (a_text: READABLE_STRING_8)
			-- Add the multiline header `a_text'
			-- Does not replace existing header with same name
			-- This could leads to multiple header with the same name
		require
			header_not_committed: not header_committed
			a_text_ends_with_single_crlf: a_text.count > 2 implies not a_text.substring (a_text.count - 2, a_text.count).same_string ("%R%N")
			a_text_does_not_end_with_double_crlf: a_text.count > 4 implies not a_text.substring (a_text.count - 4, a_text.count).same_string ("%R%N%R%N")
		ensure
			status_set: status_is_set
			message_writable: message_writable

	put_header_line (h: READABLE_STRING_8)
			-- Put header `h'
			-- Replace any existing value
		require
			header_not_committed: not header_committed

	put_header_text (a_text: READABLE_STRING_8)
			-- Put the multiline header `a_text'
			-- Overwite potential existing header
		require
			header_not_committed: not header_committed
			a_text_ends_with_single_crlf: a_text.count > 2 implies not a_text.substring (a_text.count - 2, a_text.count).same_string ("%R%N")
			a_text_does_not_end_with_double_crlf: a_text.count > 4 implies not a_text.substring (a_text.count - 4, a_text.count).same_string ("%R%N%R%N")
		ensure
			message_writable: message_writable

helpers

	add_header (a_status_code: INTEGER_32; a_headers: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Put headers with status `a_status', and headers from `a_headers'
		require
			a_status_code_valid: a_status_code > 0
			status_not_committed: not status_committed
			header_not_committed: not header_committed
		ensure
			status_code_set: status_code = a_status_code
			status_set: status_is_set
			message_writable: message_writable

	add_header_lines (a_lines: ITERABLE [READABLE_STRING_8])
			-- Add headers from `a_lines'
		require
			header_not_committed: not header_committed

	put_header (a_status_code: INTEGER_32; a_headers: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Put headers with status `a_status', and headers from `a_headers'
		require
			a_status_code_valid: a_status_code > 0
			status_not_committed: not status_committed
			header_not_committed: not header_committed
		ensure
			status_code_set: status_code = a_status_code
			status_set: status_is_set
			message_writable: message_writable

	put_header_lines (a_lines: ITERABLE [READABLE_STRING_8])
			-- Put headers from `a_lines'
		require
			header_not_committed: not header_committed

```

The other way to build headers is using the class [HTTP_HEADER](), that provide routines to build a header. It's recomended to 
take a look at constants classes such as [HTTP_MIME_TYPES](),[HTTP_HEADER_NAMES](),[HTTP_STATUS_CODE](),[HTTP_REQUEST_METHODS](), or 
[HTTP_CONSTANTS]() which groups them for convenience.


```eiffel
	custom_answer (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_text_html
			h.put_content_length (l_msg.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.bad_gateway)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end
```
The class [HTTP_HEADER]() also supplies a number of convenience routines for specifying common headers, in fact the features are inherited from the class [HTTP_HEADER_MODIFIER].


```eiffel
deferred class interface
	HTTP_HEADER_MODIFIER

feature -- Access

	date_to_rfc1123_http_date_format (dt: DATE_TIME): STRING_8
			-- String representation of `dt' using the RFC 1123

	item alias "[]" (a_header_name: READABLE_STRING_8): detachable READABLE_STRING_8 assign force
			-- First header item found for `a_name' if any
	
feature -- Status report

	has (a_name: READABLE_STRING_8): BOOLEAN
			-- Has header item for `n'?
			-- Was declared in HTTP_HEADER_MODIFIER as synonym of has_header_named.

	has_content_length: BOOLEAN
			-- Has header "Content-Length"

	has_content_type: BOOLEAN
			-- Has header "Content-Type"

	has_header_named (a_name: READABLE_STRING_8): BOOLEAN
			-- Has header item for `n'?
			-- Was declared in HTTP_HEADER_MODIFIER as synonym of has.

	has_transfer_encoding_chunked: BOOLEAN
			-- Has "Transfer-Encoding: chunked" header
	
feature -- Access: deferred

	new_cursor: INDEXABLE_ITERATION_CURSOR [READABLE_STRING_8]
			-- Fresh cursor associated with current structure.
	
feature -- Authorization

	put_authorization (a_authorization: READABLE_STRING_8)
			-- Put `a_authorization' with "Authorization" header
			-- The Authorization header is constructed as follows:
			--  1. Username and password are combined into a string "username:password".
			--  2. The resulting string literal is then encoded using Base64.
			--  3. The authorization method and a space, i.e. "Basic " is then put before the encoded string.
			-- ex: Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
	
feature -- Content related header

	add_content_type (a_content_type: READABLE_STRING_8)
			-- same as put_content_type, but allow multiple definition of "Content-Type"

	add_content_type_with_charset (a_content_type: READABLE_STRING_8; a_charset: READABLE_STRING_8)
			-- Same as put_content_type_with_charset, but allow multiple definition of "Content-Type".

	add_content_type_with_name (a_content_type: READABLE_STRING_8; a_name: READABLE_STRING_8)
			-- same as put_content_type_with_name, but allow multiple definition of "Content-Type"	

	add_content_type_with_parameters (a_content_type: READABLE_STRING_8; a_params: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Add header line "Content-Type:" + type `a_content_type' and extra paramaters `a_params'.

	put_content_disposition (a_type: READABLE_STRING_8; a_params: detachable READABLE_STRING_8)
			-- Put "Content-Disposition" header

	put_content_encoding (a_encoding: READABLE_STRING_8)
			-- Put "Content-Encoding" header of value `a_encoding'.

	put_content_language (a_lang: READABLE_STRING_8)
			-- Put "Content-Language" header of value `a_lang'.

	put_content_length (a_length: INTEGER_32)
			-- Put "Content-Length:" + length `a_length'.

	put_content_transfer_encoding (a_mechanism: READABLE_STRING_8)
			-- Put "Content-Transfer-Encoding" header with `a_mechanism'

	put_content_type (a_content_type: READABLE_STRING_8)
			-- Put header line "Content-Type:" + type `a_content_type'

	put_content_type_with_charset (a_content_type: READABLE_STRING_8; a_charset: READABLE_STRING_8)
			-- Put content type `a_content_type' with `a_charset' as "charset" parameter.

	put_content_type_with_name (a_content_type: READABLE_STRING_8; a_name: READABLE_STRING_8)
			-- Put content type `a_content_type' with `a_name' as "name" parameter.	

	put_content_type_with_parameters (a_content_type: READABLE_STRING_8; a_params: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Put header line "Content-Type:" + type `a_content_type' and extra paramaters `a_params'

	put_transfer_encoding (a_encoding: READABLE_STRING_8)
			-- Put "Transfer-Encoding" header with `a_encoding' value.

	put_transfer_encoding_binary
			-- Put "Transfer-Encoding: binary" header

	put_transfer_encoding_chunked
			-- Put "Transfer-Encoding: chunked" header
	
feature -- Content-type helpers

	put_content_type_application_javascript

	put_content_type_application_json

	put_content_type_application_pdf

	put_content_type_application_x_www_form_encoded

	put_content_type_application_zip

	put_content_type_image_gif

	put_content_type_image_jpg

	put_content_type_image_png

	put_content_type_image_svg_xml

	put_content_type_message_http

	put_content_type_multipart_alternative

	put_content_type_multipart_encrypted

	put_content_type_multipart_form_data

	put_content_type_multipart_mixed

	put_content_type_multipart_related

	put_content_type_multipart_signed

	put_content_type_text_css

	put_content_type_text_csv

	put_content_type_text_html

	put_content_type_text_javascript

	put_content_type_text_json

	put_content_type_text_plain

	put_content_type_text_xml

	put_content_type_utf_8_text_plain
	
feature -- Cookie

	put_cookie (key, value: READABLE_STRING_8; expiration, path, domain: detachable READABLE_STRING_8; secure, http_only: BOOLEAN)
			-- Set a cookie on the client's machine
			-- with key 'key' and value 'value'.
			-- Note: you should avoid using "localhost" as `domain' for local cookies
			--       since they are not always handled by browser (for instance Chrome)
		require
			make_sense: (key /= Void and value /= Void) and then (not key.is_empty and not value.is_empty)
			domain_without_port_info: domain /= Void implies domain.index_of (':', 1) = 0

	put_cookie_with_expiration_date (key, value: READABLE_STRING_8; expiration: DATE_TIME; path, domain: detachable READABLE_STRING_8; secure, http_only: BOOLEAN)
			-- Set a cookie on the client's machine
			-- with key 'key' and value 'value'.
		require
			make_sense: (key /= Void and value /= Void) and then (not key.is_empty and not value.is_empty)
	
feature -- Cross-Origin Resource Sharing

	put_access_control_allow_all_origin
			-- Put "Access-Control-Allow-Origin: *" header.

	put_access_control_allow_credentials (b: BOOLEAN)
			-- Indicates whether or not the response to the request can be exposed when the credentials flag is true.
			-- When used as part of a response to a preflight request, this indicates whether or not the actual request can be made using credentials.
			-- Note that simple GET requests are not preflighted, and so if a request is made for a resource with credentials,
			-- if this header is not returned with the resource, the response is ignored by the browser and not returned to web content.
			-- ex: Access-Control-Allow-Credentials: true | false

	put_access_control_allow_headers (a_headers: READABLE_STRING_8)
			-- Put "Access-Control-Allow-Headers" header. with value `a_headers'
			-- Used in response to a preflight request to indicate which HTTP headers can be used when making the actual request.
			-- ex: Access-Control-Allow-Headers: <field-name>[, <field-name>]*

	put_access_control_allow_iterable_headers (a_fields: ITERABLE [READABLE_STRING_8])
			-- Put "Access-Control-Allow-Headers" header. with value `a_headers'
			-- Used in response to a preflight request to indicate which HTTP headers can be used when making the actual request.
			-- ex: Access-Control-Allow-Headers: <field-name>[, <field-name>]*

	put_access_control_allow_methods (a_methods: ITERABLE [READABLE_STRING_8])
			-- If `a_methods' is not empty, put `Access-Control-Allow-Methods' header with list `a_methods' of methods
			-- `a_methods' specifies the method or methods allowed when accessing the resource.
			-- This is used in response to a preflight request.
			-- ex: Access-Control-Allow-Methods: <method>[, <method>]*

	put_access_control_allow_origin (a_origin: READABLE_STRING_8)
			-- Put "Access-Control-Allow-Origin: " + `a_origin' header.
			-- `a_origin' specifies a URI that may access the resource
	
feature -- Date

	put_current_date
			-- Put current date time with "Date" header

	put_date (a_date: READABLE_STRING_8)
			-- Put "Date: " header

	put_last_modified (a_utc_date: DATE_TIME)
			-- Put UTC date time `dt' with "Last-Modified" header

	put_utc_date (a_utc_date: DATE_TIME)
			-- Put UTC date time `a_utc_date' with "Date" header
			-- using RFC1123 date formating.
	
feature -- Header change: deferred

	add_header (h: READABLE_STRING_8)
			-- Add header `h'
			-- if it already exists, there will be multiple header with same name
			-- which can also be valid
		require
			h_not_empty: h /= Void and then not h.is_empty

	put_header (h: READABLE_STRING_8)
			-- Add header `h' or replace existing header of same header name
		require
			h_not_empty: h /= Void and then not h.is_empty
	
feature -- Header change: general

	add_header_key_value (a_header_name, a_value: READABLE_STRING_8)
			-- Add header `a_header_name:a_value'.
			-- If it already exists, there will be multiple header with same name
			-- which can also be valid
		ensure
			added: has_header_named (a_header_name)

	force (a_value: detachable READABLE_STRING_8; a_header_name: READABLE_STRING_8)
			-- Put header `a_header_name:a_value' or replace existing header of name `a_header_name'.

	put_header_key_value (a_header_name, a_value: READABLE_STRING_8)
			-- Add header `a_header_name:a_value', or replace existing header of same header name/key
		ensure
			added: has_header_named (a_header_name)

	put_header_key_values (a_header_name: READABLE_STRING_8; a_values: ITERABLE [READABLE_STRING_8]; a_separator: detachable READABLE_STRING_8)
			-- Add header `a_header_name: a_values', or replace existing header of same header values/key.
			-- Use Comma_space as default separator if `a_separator' is Void or empty.
		ensure
			added: has_header_named (a_header_name)
	
feature -- Method related

	put_allow (a_methods: ITERABLE [READABLE_STRING_8])
			-- If `a_methods' is not empty, put `Allow' header with list `a_methods' of methods
	
feature -- Others	

	put_cache_control (a_cache_control: READABLE_STRING_8)
			-- Put "Cache-Control" header with value `a_cache_control'

	put_expires (a_seconds: INTEGER_32)
			-- Put "Expires" header to `a_seconds' seconds

	put_expires_date (a_utc_date: DATE_TIME)
			-- Put "Expires" header with UTC date time value
			-- formatted following RFC1123 specification.

	put_expires_string (a_expires: STRING_8)
			-- Put "Expires" header with `a_expires' string value

	put_pragma (a_pragma: READABLE_STRING_8)
			-- Put "Pragma" header with value `a_pragma'

	put_pragma_no_cache
			-- Put "Pragma" header with "no-cache" a_pragma
	
feature -- Redirection

	put_location (a_uri: READABLE_STRING_8)
			-- Tell the client the new location `a_uri'
			-- using "Location" header.
		require
			a_uri_valid: not a_uri.is_empty

	put_refresh (a_uri: READABLE_STRING_8; a_timeout_in_seconds: INTEGER_32)
			-- Tell the client to refresh page with `a_uri' after `a_timeout_in_seconds' in seconds
			-- using "Refresh" header.
		require
			a_uri_valid: not a_uri.is_empty
	
end -- class HTTP_HEADER_MODIFIER
```



## HTTP 1.1 Response Headers

There are four categories for response header fields:
 - [Control Data](https://httpwg.github.io/specs/rfc7231.html#response.control.data) : Supply control data that supplements the status code, directs caching, or instructs the client where to go next.
 	 - Age,Cache-Control,Expires,Date,Location,Retry-After,Vary,Warning.
 - [Validator](https://httpwg.github.io/specs/rfc7231.html#response.validator): Validator header fields convey metadata about the selected representation. In responses to safe requests, validator fields describe the selected representation chosen by the origin server while handling the response.
 - [Authentication Challenges](https://httpwg.github.io/specs/rfc7231.html#response.auth): Indicate what mechanisms are available for the client to provide authentication credentials in future requests.
 - [Response Context](https://httpwg.github.io/specs/rfc7231.html#response.context): Provide more information about the target resource for potential use in later requests.



| [Handling Requests: Header Fields](/workbook/handling_request/headers.md) | [Handling Cookies](/workbook/handling_cookies/handling_cookies.md)
