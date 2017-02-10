Nav: [Workbook](../workbook.md) :: [Handling Requests: Form/Query parameters](./form.md) :: [Generating Responses](../generating_response/generating_response.md)


# Handling Requests: Headers

##### Introduction
- The [HTTP request header fields (also known as "headers")](https://httpwg.github.io/specs/rfc7231.html#request.header.fields) are set by the client (usually web browser) and sent in the header of the http request text (see http protocol), as opposed to form or query parameters [Form Data]().
- Query parameters are encoded in the URL [GET requests](https://httpwg.github.io/specs/rfc7230.html#http.message).
- Form parameters are encoded in the request message for [POST/PUT requests.](https://httpwg.github.io/specs/rfc7230.html#http.message).

A request usually includes the header fields [Accept, Accept-Encoding, Connection, Cookie, Host, Referer, and User-Agent](https://httpwg.github.io/specs/rfc7231.html#request.header), defining important information about how the server should process the request. And then, the server needs to read the request header fields to use those informations.

##### Table of Contents  
- [Reading HTTP Header fields](#read_header)
- [Reading HTTP Request line](#read_line)
- [Understanding HTTP header fields](#understand)
	- [Accept](#accept)
	- [Accept-Charset](#accept_charset)
	- [Accept-Encoding](#accept_encoding)
	- [Accept-Language](#accept_language)
	- [Connection](#connection)
	- [Authorization](#authorization)
	- [Content-length](#content-length)
	- [Cookie](#cookie)
	- [Host](#host)
	- [If-Modified-Since](#if-modified-since)
	- [If-Unmodified-Since](#if-unmodified-since)
	- [Referer](#referer)
	- [User-Agent](#user-agent)
- [Example: Request Headers](#example)
- [Example: How to compress pages](#compress) 
- [Example: Detecting Browser Types](#browser-types)
- [Example: CGI Variables](#cgi-variables)
 

That section explains how to read HTTP information sent by the browser via the request header fields. Mostly by defining the most important HTTP request header fields, for more information, read [HTTP 1.1 specification](https://httpwg.github.io/specs/).

## Prerequisites
The Eiffel Web Framework is using the traditional Common Gateway Interface (CGI) programming interface to access the header fields, query and form parameters.
Among other, this means the header fields are exposed with associated CGI field names:
- the header field name are uppercased, and any dash "-" replaced by underscore "_".
- and also prefixed by "HTTP_" except for CONTENT_TYPE and CONTENT_LENGTH. 
- For instance `X-Server` will be known as `HTTP_X_SERVER`.

<a name="read_header"></a>

## Reading HTTP Header fields
EWF [WSF_REQUEST]() class provides features to access HTTP headers.

Reading most headers is straightforward by calling:
- the corresponding `http_*` functions such as `http_accept` for header "Accept".
- or indirectly using the `meta_string_variable (a_name)` function by passing the associated CGI field name.
In both cases, if the related header field is supplied by the request, the result is a string value, otherwise it is Void. 

Note: always check if the result of those functions is non-void before using it.

* Cookies:
	- To iterate on all cookies valued, use `cookies: ITERABLE [WSF_VALUE]`
	- To retrieve a specific cookie value,  use `cookie (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE`

* Authorization
	- To read the Authorization header, first check its type with: `auth_type: detachable READABLE_STRING_8`
	- And its value via `http_authorization: detachable READABLE_STRING_8 --Contents of the Authorization: header from the current wgi_request, if there is one.`

* Content_length
	- If supplied, get the content length as an string value: `content_length: detachable READABLE_STRING_8`
	- or directly as a natural value with `content_length_value: NATURAL_64` 

* Content_type
	- If supplied, get the content type as an string value with `content_type: detachable HTTP_CONTENT_TYPE`

Due to CGI compliance, the original header names are not available, however the function `raw_header_data` may return the http header data as a string value (warning: this may not be available, depending on the underlying connector). Apart from very specific cases (proxy, debugging, ...), it should not be useful.
Note: CGI variables are information about the current request (and also about the server). Some are based on the HTTP request line and headers (e.g., form parameters, query parameters), others are derived from the socket itself (e.g., the name and IP address of the requesting host), and still others are taken from server installation parameters (e.g., the mapping of URLs to actual paths). 

<a name="read_line"></a>

#### Retrieve information from the Request Line

For convenience, the following sections refer to a request starting with line:
```
GET http://eiffel.org/search?q=EiffelBase  HTTP/1.1
```

Overview of the features

* HTTP method 
	- The function `request_method: READABLE_STRING_8` gives access to the HTTP request method, (usually `GET` or `POST` in conventional Web Applications), but with the raise of REST APIs other methods are also frequently used such as `HEAD`, `PUT`, `DELETE`, `OPTIONS`, or `TRACE`. 
	A few functions helps determining quickly the nature of the request method:
	- `is_get_request_method: BOOLEAN -- Is Current a GET request method?`
	- `is_put_request_method: BOOLEAN -- Is Current a PUT request method?`
	- `is_post_request_method: BOOLEAN -- Is Current a POST request method?`
	- `is_delete_request_method: BOOLEAN -- Is Current a DELETE request method?`

	In our example the request method is `GET`
	
 * Query String
 	- The query string for the example is `q=EiffelBase`
 	- `query_string: READABLE_STRING_8`

 * Protocol 
 	- The feature return the third part of the request line, which is generally HTTP/1.0 or HTTP/1.1.
	- `server_protocol: READABLE_STRING_8`
    In the example the request method is `HTTP/1.1`


<a name="understand"></a>

#### Understanding HTTP 1.1 Request Headers
Access to the request headers permits the web server applications or APIs to perform optimizations and provide behavior that would not be possible without them for instance such as adapting the response according to the browser preferences.
This section summarizes the headers most often used; for more information, see the [HTTP 1.1 specification](https://httpwg.github.io/specs/), note that [RFC 2616 is dead](https://www.mnot.net/blog/2014/06/07/rfc2616_is_dead).

<a name="accept"></a>

 * [Accept](https://httpwg.github.io/specs/rfc7231.html#header.accept)
 	- The "Accept" header field can be used by user agents (browser or other clients) to define response media types that are acceptable. Accept header fields can be used to indicate that the request is limited to a small set of desired types, as in the case of a request for an inline image.
 	For example, assume an APIs Learn4Kids can respond with XML or JSON data (JSON format have some advantages over XML, readability, parsing etc...), a client can define its preference using "Accept: application/json" to request data in JSON format, or "Accept: application/xml" to get XML format. In other case the server sends a not acceptable response. Note that the client can define an ordered list of accepted content types, including "*", the client will get the response and know the content type via the response header field "Content-Type". Related [Content-Negotiation]()

<a name="accept_charset"></a>

 * [Accept-Charset](https://httpwg.github.io/specs/rfc7231.html#header.accept-charset)
	- The "Accept-Charset" header field can be sent by a user agent (browser or other clients) to indicate which charsets are acceptable in textual response content (e.g., ISO-8859-1).

<a name="accept_encoding"></a>

 * [Accept-Encoding](https://httpwg.github.io/specs/rfc7231.html#header.accept-encoding)
	- The "Accept-Encoding" header field can be used by user agents (browser or other clients) to indicate which response content-codings (`gzip`, `compress`) are acceptable in the response. An "identity" token is used as a synonym for "no encoding" in order to communicate when no encoding is preferred. If the server receives this header, it is free to encode the page by using one of the content-encodings specified (usually to reduce transmission time), sending the `Content-Encoding` response header to indicate that it has done so.

<a name="accept_language"></a>

 * [Accept-Language](https://httpwg.github.io/specs/rfc7231.html#header.accept-language)
 	- The "Accept-Language" header field can be used by user agents (browser or other client) to indicate the set of natural languages that are preferred in the response in case the server can produce representation in more than one language. The value of the header should be one of the standard language codes such as en, en-us, da, etc. See RFC 1766 for details (start at http://www.rfc-editor.org/ to get a current list of the RFC archive sites).

<a name="connection"></a>

 * [Connection](https://httpwg.github.io/specs/rfc7230.html#header.connection)
 	- The "Connection" header field allows the sender to indicate desired control options for the current connection, for example if it can hanlde persistent HTTP connections.
 	By default HTTP/1.1 uses "persistent connections", allowing multiple requests and responses to be carried over a single connection. The "close" connection option is used to signal that a connection will not persist after the current request/response.

<a name="authorization"></a>

 * [Authorization](https://httpwg.github.io/specs/rfc7235.html#header.authorization)
 	- The header is used by user agents to authenticate themselves when accessing password protected resources.

<a name="content-length"></a>

 * [Content-Length](https://httpwg.github.io/specs/rfc7230.html#header.content-length)
	- For messages that includes a payload body, the Content-Length field-value provides the framing information necessary to determine where the body (and message) ends.

<a name="cookie"></a>

 * [Cookie](https://httpwg.github.io/specs/rfc6265.html)
	-  The Cookie header contains cookies received by the user agent in previous Set-Cookie headers. The origin server is free to ignore the Cookie header or use its contents for an application-specific purpose. (Related State Management).

<a name="host"></a>

 * [Host](https://httpwg.github.io/specs/rfc7230.html#header.host)
 	- The "Host" header field provides the host and port information from the target URI, enabling the origin server to distinguish among resources while serving requests for multiple host names on a single IP address. In HTTP 1.1, browsers and other clients are required to specify this header, which indicates the host and port as given in the original URL. 

<a name="if-modified-since"></a>

 * [If-Modified-Since](https://httpwg.github.io/specs/rfc7232.html#header.if-modified-since)
	- The "If-Modified-Since" header field makes a GET or HEAD request method conditional on the selected representation's modification date being more recent than the date provided in the field-value. Transfering of the selected representation's data is avoided if that data has not changed. So, indicates that the user agents wants the page only if it has been changes after the specified date. The server sends a 304 resource not modified if not has a newer result representation available.

<a name="if-unmodified-since"></a>

 * [If-Unmodified-Since](https://httpwg.github.io/specs/rfc7232.html#header.if-unmodified-since)
	- The "If-Unmodified-Since" header field makes the request method conditional on the selected representation's last modification date being earlier than or equal to the date provided in the field-value. The operation should succeed only if the document is older than the specified date.

Generally, If-Modified-Since is used for GET requests (“give me the document only if it is newer than my cached version”), whereas If-Unmodified-Since is used for PUT requests (“update this document only if nobody else has changed it since I generated it”). 

<a name="referer"></a>

 * [Referer](https://httpwg.github.io/specs/rfc7231.html#header.referer)
	- The "Referer" header field allows the user agent to specify a URI reference for the resource from which the target URI was obtained (i.e., the "referrer", though the field name is misspelled). A user agent MUST NOT include the fragment and userinfo components of the URI reference [RFC3986], if any, when generating the Referer field value. This header indicates the URL of the referring Web page. 

For example, if you are at Web page A and click on a link to Web page B, the URL of Web page A is
included in the Referer header when the browser requests Web page B. 

<a name="user-agent"></a>

 * [User-Agent](https://httpwg.github.io/specs/rfc7231.html#header.user-agent)
 	- The "User-Agent" header field contains information about the user agent of the request, which is often used by servers to help identify the scope of reported interoperability problems, to work around or tailor responses to avoid particular user agent limitations, and for analytics regarding browser or operating system use or device.

**Note**: the example shows the **WSF_EXECUTION** implementation, that will be used by the service launcher.

<a name="example"></a>

#### Building a Table of All Request Headers

The following [EWF service](./headers/header_fields/application.e) code simply uses an ```html_template``` to fill a table (names and values) with all the headers fields it receives.

The service accomplishes this task by calling ```req.meta_variables``` feature to get an ```ITERABLE [WSF_STRING]```, an structure that can be iterated over using ```across...loop...end```, then it checks if the name has the prefix ```HTTP_``` and if it is true, put the header name and value in a row. (the name in the left cell, the value in the right cell).

The service also writes three components of the main request line (method, URI, and protocol), and also the raw header. 

```eiffel
class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			l_raw_data: STRING
			l_page_response: STRING
			l_rows: STRING
		do
			create l_page_response.make_from_string (html_template)
			if  req.path_info.same_string ("/") then

					-- HTTP method
				l_page_response.replace_substring_all ("$http_method", req.request_method)
					-- URI
				l_page_response.replace_substring_all ("$uri", req.path_info)
					-- Protocol
				l_page_response.replace_substring_all ("$protocol", req.server_protocol)

					-- Fill the table rows with HTTP Headers
				create l_rows.make_empty
				across req.meta_variables as ic loop
					if ic.item.name.starts_with ("HTTP_") then
						l_rows.append ("<tr>")
						l_rows.append ("<td>")
						l_rows.append (ic.item.name)
						l_rows.append ("</td>")
						l_rows.append ("<td>")
						l_rows.append (ic.item.value)
						l_rows.append ("</td>")
						l_rows.append ("</tr>")
					end
				end

				l_page_response.replace_substring_all ("$rows", l_rows)

					-- Reading the raw header
				if attached req.raw_header_data as l_raw_header then
					l_page_response.replace_substring_all ("$raw_header", l_raw_header)
				end
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_page_response.count.out]>>)
				res.put_string (l_page_response)
			end
		end

	html_template: STRING = "[
				<!DOCTYPE html>
				<html>
				<head>
					<style>
						thead {color:green;}
						tbody {color:blue;}
						table, th, td {
						    border: 1px solid black;
						}
					</style>
				</head>
				
				<body>
				    <h1>EWF service example: Showing Request Headers</h1>
				   
				    <strong>HTTP METHOD:</strong>$http_method<br/>
				    <strong>URI:</strong>$uri<br>
				    <strong>PROTOCOL:</strong>$protocol<br/>
				    <strong>REQUEST TIME:</strong>$time<br/>
				     
				    <br> 
					<table>
					   <thead>
					   <tr>
					        <th>Header Name</th>
						    <th>Header Value</th>
					   </tr>
					   </thead>
					   <tbody>
					   $rows
					   </tbody>
					</table>
					
					
					<h2>Raw header</h2>
					
					$raw_header
				</body>
				</html>
			]"
end
```

<a name="compress"></a>

#### How to compress pages
To be completed.


<a name="browser-types"></a>

#### Detecting Browser Types

The User-Agent header identifies the specific browser/client that is sending the request. The following code shows an [EWF service](./headers/browser_name/application.e) that sends browser-specific responses.

The examples uses the ideas based on the [Browser detection using the user agent](https://developer.mozilla.org/en-US/docs/Browser_detection_using_the_user_agent) article.
Basically the code check if the header `user_agent` exist and then call the ```browser_name (a_user_agent: READABLE_STRING_8): READABLE_STRING_32``` feature to retrieve the current browser name or Unknown in other case. 

```eiffel
class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			l_raw_data: STRING
			l_page_response: STRING
			l_rows: STRING
		do
			create l_page_response.make_from_string (html_template)	
		if  req.path_info.same_string ("/") then

					-- retrieve the user-agent
				if attached req.http_user_agent as l_user_agent then
					l_page_response.replace_substring_all ("$user_agent", l_user_agent)
					l_page_response.replace_substring_all ("$browser", browser_name (l_user_agent))
				else
					l_page_response.replace_substring_all ("$user_agent", "[]")
					l_page_response.replace_substring_all ("$browser", "Unknown, the user-agent was not present.")
				end
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_page_response.count.out]>>)
				res.put_string (l_page_response)
			end
		end


feature -- Browser utility

	browser_name (a_user_agent: READABLE_STRING_8): READABLE_STRING_32
			-- Browser name.
			--						Must contain	Must not contain	
			--	Firefox				Firefox/xyz		Seamonkey/xyz	
			--	Seamonkey			Seamonkey/xyz	 	
			--	Chrome				Chrome/xyz		Chromium/xyz	
			--	Chromium			Chromium/xyz	 	
			--	Safari				Safari/xyz		Chrome/xyz
			--										Chromium/xyz
			--	Opera				OPR/xyz [1]
			--						Opera/xyz [2]
			--	Internet Explorer	;MSIE xyz;	 	Internet Explorer doesn't put its name in the BrowserName/VersionNumber format

		do
			if
				a_user_agent.has_substring ("Firefox") and then
				not a_user_agent.has_substring ("Seamonkey")
			then
				Result := "Firefox"
			elseif a_user_agent.has_substring ("Seamonkey") then
				Result := "Seamonkey"
			elseif a_user_agent.has_substring ("Chrome") and then not a_user_agent.has_substring ("Chromium")then
				Result := "Chrome"
			elseif a_user_agent.has_substring ("Chromium") then
				Result := "Chromiun"
			elseif a_user_agent.has_substring ("Safari") and then not (a_user_agent.has_substring ("Chrome") or else a_user_agent.has_substring ("Chromium"))  then
				Result := "Safari"
			elseif a_user_agent.has_substring ("OPR") or else  a_user_agent.has_substring ("Opera") then
				Result := "Opera"
			elseif a_user_agent.has_substring ("MSIE") or else a_user_agent.has_substring ("Trident")then
				Result := "Internet Explorer"
 			else
				Result := "Unknown"
			end
		end


	html_template: STRING = "[
				<!DOCTYPE html>
				<html>
				<head>
				</head>
				
				<body>
				    <h1>EWF service example: Showing Browser Dectection Using User-Agent</h1> <br>
				    
				    <strong>User Agent:</strong> $user_agent <br>
				   
				    <h2>Enjoy using $browser </h2> 
				</body>
				</html>
			]"
end
```
Let see some results, we will show the html returned

**Internet Explorer**
---
```
<h1>EWF service example: Showing Browser Dectection Using User-Agent</h1></br>

<strong>User Agent:</strong> Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; MDDCJS; rv:11.0) like Gecko <br>

<h2> Enjoy using Internet Explorer </h2>
```

**Chrome**
---
```
<h1>EWF service example: Showing Browser Dectection Using User-Agent</h1></br>

<strong>User Agent:</strong> Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.91 Safari/537.36  <br>

<h2> Enjoy using Chrome </h2>
```

As an exercise, try to write a similar service to retrieve the OS family using the User-Agent information.

<a name="cgi-variables"></a>

[Meta-variables](https://tools.ietf.org/html/rfc3875#section-4.1) contains data about the request, they are identified by case-insensitive names. In this section, the purpose is to show a similar example to HEADERS FIELDS, but in this case building a table showing the standard CGI variables.


	* [AUTH_TYPE](https://tools.ietf.org/html/rfc3875#section-4.1.1).
	* [CONTENT_LENGTH](https://tools.ietf.org/html/rfc3875#section-4.1.2)
	* [CONTENT_TYPE](https://tools.ietf.org/html/rfc3875#section-4.1.3)
	* [GATEWAY_INTERFACE](https://tools.ietf.org/html/rfc3875#section-4.1.4)
	* [PATH_INFO](https://tools.ietf.org/html/rfc3875#section-4.1.5)
	* [PATH_TRANSLATED](https://tools.ietf.org/html/rfc3875#section-4.1.6)
	* [QUERY_STRING](https://tools.ietf.org/html/rfc3875#section-4.1.7)
	* [REMOTE_ADDR](https://tools.ietf.org/html/rfc3875#section-4.1.8)
	* [REMOTE_HOST](https://tools.ietf.org/html/rfc3875#section-4.1.9)
	* [REMOTE_IDENT](https://tools.ietf.org/html/rfc3875#section-4.1.10)
	* [REMOTE_USER](https://tools.ietf.org/html/rfc3875#section-4.1.11)
	* [REQUEST_METHOD](https://tools.ietf.org/html/rfc3875#section-4.1.12)
	* [SCRIPT_NAME](https://tools.ietf.org/html/rfc3875#section-4.1.13)
	* [SERVER_NAME](https://tools.ietf.org/html/rfc3875#section-4.1.14)
	* [SERVER_PROTOCOL](https://tools.ietf.org/html/rfc3875#section-4.1.15)
	* [SERVER_SOFTWARE](https://tools.ietf.org/html/rfc3875#section-4.1.16)

**Example**
An [EWF service](./headers/cgi_variables/application.e) that shows the CGI variables, creates a table showing the values of all the CGI variables.


Nav: [Workbook](../workbook.md) :: [Handling Requests: Form/Query parameters](./form.md) :: [Generating Responses](../generating_response/generating_response.md)

