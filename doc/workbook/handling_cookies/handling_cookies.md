Nav: [Workbook](../workbook.md) :: [Generating Responses](../generating_response/generating_response.md)

# Handling Cookies

- [Cookie](#cookie)
	- [Cookie Porperties](#properties)
- [Write and Read Cookies](#set_get)
	- [How to set a cookie](#set_cookie)
	- [How to read a cookie](#read_cookie)
- [Examples](#examples)		

<a name="cookie"></a>

## Cookie
A [cookie](http://httpwg.github.io/specs/rfc6265.html) is a piece of data that can be stored in a browser's cache. If you visit a web site and then revisit it, the cookie data can be used to identify you as a return visitor. Cookies enable state information, such as an online shopping cart, to be remembered. A cookie can be short term, holding data for a single web session, that is, until you close the browser, or a cookie can be longer term, holding data for a week or a year.

Cookies are used a lot in web client-server communication.

- HTTP State Management With Cookies
	 
- Personalized response to the client based on their preference, for example we can set background color as cookie in client browser and then use it to customize response background color, image etc.

Server send cookies to the client

>Set-Cookie: _Framework=EWF; Path=/; Expires=Tue, 10 Mar 2015 13:28:10 GMT; HttpOnly%R


Client send cookies to server

>Cookie: _Framework=EWF



<a name="properties"></a>

### Cookie properties

 - Comment: describe the purpose of the cookie. Note that server doesn’t receive this information when client sends cookie in request header. 
 - Domain: domain name for the cookie.
 - Expiration/MaxAge: Expiration time of the cookie, we could also set it in seconds.  (At the moment Max-Age attribute is not supported)
 - Name: name of the cookie.
 - Path: path on the server to which the browser returns this cookie. Path instruct the browser to send cookie to a particular resource.
 - Secure: True, if the browser is sending cookies only over a secure protocol, False in other case.
 - Value: Value of th cookie as string.
 - HttpOnly: Checks whether this Cookie has been marked as HttpOnly. 
 - Version:

<a name="set_get"></a>

## Write and Read Cookies.

To send a cookie to the client we should use the **HTTP_HEADER** class, and call ```h.put_cookie``` feature or 
```h.put_cookie_with_expiration_date``` feature, see [How to set Cookies]() to learn the details, and the set it to response object **WSF_RESPONSE** as we saw previously. 

We will show an example.

To Read incomming cookies we can read all the cookies with 

```
cookies: ITERABLE [WSF_VALUE]
			-- All cookies.
``` 
which return an interable of WSF_VALUE objects corresponding to the cookies the browser has associated with the web site.
We can also check if a particular cookie by name using 

```
WSF_REQUEST.cookie (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Field for name `a_name'.
``` 
feature.


<a name="set_cookie"></a>

### How to set Cookies
Here we have the feature definitions to set cookies

```eiffel
deferred class interface
	HTTP_HEADER_MODIFIER

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
```

Example of use:

```eiffel
   response_with_cookies (res: WSF_RESPONSE)
		local
			l_message: STRING
			l_header: HTTP_HEADER
			l_time: HTTP_DATE
		do
				create l_header.make
				create l_time.make_now_utc
				l_time.date_time.day_add (40)
				l_header.put_content_type_text_html
				l_header.put_cookie_with_expiration_date ("EWFCookie", "EXAMPLE",l_time.date_time, "/", Void, False, True)
				res.put_header_text (l_header.string)
				res.put_string (web_page)
		end		
```
<a name="read_cookie"></a>

### How to read Cookies

Reading a particular cookie
```eiffel
		if req.cookie ("EWFCookie") = Void then
			do_something
		end
````		

Reading all the cookies

```Eiffel
	across req.cookies as ic loop
		print (ic.item.name)
	end
```


<a name="examples"></a>

### Example
The following EWF service shows a basic use of cookies. 
	1. It display a message to first-time visitors.
	2. Display a welcome back message if a visitor return.
	3. A visitor page, counting the number of visits to the page (track user access counts).
	4. A cookie with an expiration of 120 seconds.
	5. A cookie with an session level, valid in browser session.

```eiffel
note
	description : "Basic Service that build a generic front to demonstrate the use of Cookies"
	date        : "$Date$"
	revision    : "$Revision$"

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
			l_message: STRING
			l_header: HTTP_HEADER
			l_time: HTTP_DATE
			l_cookies: STRING
			l_answer: STRING
		do
				-- all the cookies
			create l_cookies.make_empty
			across req.cookies as ic loop
					l_cookies.append (ic.item.name)
					l_cookies.append("<br>")
			end

			if req.path_info.same_string ("/") then
				create l_header.make
				create l_answer.make_from_string (web_page)
				if  req.cookie ("_EWF_Cookie") = Void then
						-- First access the the home page, find a cookie with specific name `_EWF_Cookie'
					l_answer.replace_substring_all ("$header_title", "Hey, thanks for access our cool site, this is your first acess")
					l_answer.replace_substring_all ("$cookies", l_cookies)
					create l_time.make_now_utc
					l_time.date_time.day_add (40)
					l_header.put_cookie_with_expiration_date ("_EWF_Cookie", "EXAMPLE",l_time.date_time, "", Void, False, True)
				else
					   -- No a new access
					l_answer.replace_substring_all ("$header_title", "Welcome back, please check all the new things we have!!!")
					l_answer.replace_substring_all ("$cookies", l_cookies)
				end
				l_header.put_content_type_text_html
				l_header.put_content_length (l_answer.count)
				res.put_header_text (l_header.string)
				res.put_string (l_answer)

			elseif req.path_info.same_string ("/visitors")  then
				create l_header.make
				create l_answer.make_from_string (visit_page)
				if req.cookie ("_visits") = Void then
						-- First access the the visit page, find a cookie with specific name `_visits'
					l_answer.replace_substring_all ("$visit", "1")
					l_answer.replace_substring_all ("$cookies", l_cookies)
					create l_time.make_now_utc
					l_time.date_time.day_add (40)
					l_header.put_cookie_with_expiration_date ("_visits", "1",l_time.date_time, "/visitors", Void, False, True)

				else
					if attached {WSF_STRING} req.cookie ("_visits") as l_visit then
						create l_time.make_now_utc
						l_time.date_time.day_add (40)
						l_answer.replace_substring_all ("$visit", (l_visit.value.to_integer + 1).out )
						l_answer.replace_substring_all ("$cookies", l_cookies)
						l_header.put_cookie_with_expiration_date ("_visits", (l_visit.value.to_integer + 1).out,l_time.date_time, "/visitors", Void, False, True)
					end
				end
				create l_time.make_now_utc
				l_time.date_time.second_add (120)
				l_header.put_content_type_text_html
					-- This cookie expires in 120 seconds, its valid for 120 seconds
				l_header.put_cookie_with_expiration_date ("_Framework", "EWF",l_time.date_time, "/", Void, False, True)
					-- This is a session cookie, valid only to the current browsing session.
				l_header.put_cookie ("Session", "Cookie",Void, "/", Void, False, True)
				l_header.put_content_length (l_answer.count)
				res.add_header_text (l_header.string)
				res.put_string (l_answer)
			end

		end

feature -- Home Page

	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>EWF Handling Cookies</title>
		</head>
		<body>
			<div class="right">
				<h2>$header_title</h2>	
			</div>
			
			<div class="right">
				<a href="/visitors">Visitors</a>
			</div>
			
			<div>
				<h3>Cookies for the home page</h3>
				$cookies 
			</div>
		</body>
	</html>
]"


visit_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>EWF Handling Visit Page</title>
		</head>
		<body>
			<div class="right">
				<h2>The number of visits is $visit</h2>
			</div>
			
			<div>
				<h3>Cookies for the Visit page</h3>
				$cookies 
			</div>
			</br>
			
			<div>
				Back to <a href="/"> Home </a> 
			</div>

			<div id="footer">
				<p>EWF Example Cookies</p>
			</div>
		</body>
	</html>
]"

end

```


Nav: [Workbook](../workbook.md) :: [Generating Responses](../generating_response/generating_response.md)
