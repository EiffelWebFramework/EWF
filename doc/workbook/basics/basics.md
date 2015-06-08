Nav: [Workbook](../workbook.md) | [Handling Requests: Form/Query Parameter](/workbook/handling_request/form.md)


## EWF basic service

##### Table of Contents  
- [Basic Structure](#structure)  
- [Service to Generate Plain Text](#text) 
	- [Source code](#source_1) 	
- [Service to Generate HTML](#html)
	- [Source code](#source_2) 	


<a name="structure"/>
## EWF service structure

The following code describes the basic structure of an EWF basic service that handles HTTP requests.

```eiffel
class
	SERVICE_TEMPLATE

inherit
	WSF_DEFAULT_SERVICE  -- Todo explain this, and the concept of launchers and connectors ()

create
	make_and_launch

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			-- To read incoming HTTP request, we need to use `req'

			-- May require talking to databases or other services.	
 
			-- To send a response we need to setup, the status code and
			-- the response headers and the content we want to send out our client
		end
end
```

When using the "nino" connector, by default the service listens on port 80, but often this port is already used by other applications, so it is recommended to use another port.
To define another port, redefine the feature `initialize' and set up a new port number using the service options (see below).

```eiffel
class
	SERVICE_TEMPLATE
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
			-- on port 9090
		do
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incoming request.
		do
			-- To read incoming HTTP requires, we need to use `req'

			-- May require talking to databases or other services.	
 
			-- To send a response we need to setup, the status code and
			-- the response headers and the content we want to send out client
		end
end
```

The **WSF_REQUEST** gives access to the incoming data; the class provides features to get information such as request method, form data, query parameters, uploaded files, HTTP request headers, and hostname of the client among others. 
The **WSF_RESPONSE** provides features to define the response with information such as HTTP status codes (10x,20x, 30x, 40x, and 50x), response headers (Content-Type, Content-Length, etc.) and obviously the body of the message itself.

**SERVICE_TEMPLATE** is the root class of our example, it launches the application, using the corresponding connector, Which connector? this depends how you want to run it cgi, fcgi or nino. For development is recommended to use Nino, a standalone web server written in Eiffel, and run the execution within the EiffelStudio debugger. For production fcgi (or cgi) using Apache or another popular web server.

The **SERVICE_TEMPLATE** class inherits from _WSF_DEFAULT_SERVICE_ class, and this one also inherits from other interfaces. Let’s describe them in a few words.

![Service Template Hierarchy](/workbook/SERVICE_TEMPLATE.png "Service Template")

**WS_LAUNCHABLE_SERVICE** inherit from **WS_SERVICE** class, which is the low level entry point in EWF, handling each incoming request with a single procedure ```execute (req: WSF_REQUEST; res: WSF_RESPONSE) ...```. And also provides a way to launch our application using different kind of connectors. Below a [BON diagram] (http://www.bon-method.com/index_normal.htm) showing the different kind of connectors.

![Launcher Hierarchy](/app/doc/WSF_SERVICE_LAUNCHER.png "Launcher")

A basic EWF service inherits from **WSF_DEFAULT_SERVICE** (for other options see [?]).
And then you only need to implement the **execute** feature, get data from the request *req* and write the response in *res*.

<a name="text"/>
## A simple Service to Generate Plain Text.

Before to continue, it is recommended to review the getting started guided.

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
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/plain"], ["Content-Length", "11"]>>)
			res.put_string ("Hello World")
		end

end
```
<a name="source_1"></a>
##### Source code
The source code is available on Github. You can get it by running the command:

```git clone https://github.com/EiffelWebFramework/ewf_examples.git```

The example of simple service that generate plain text response is located in the directory $PATH/ewf_examples/workbook/basics/simple, where $PATH is where you run ```git clone``` . Just double click on the simple.ecf file and select the simple_nino target or if you prefer the command line, run the command:

```estudio -config simple.ecf -target simple_nino```

<a name="html"></a>
## A Service to Generate HTML.
To generate HTML, it's needed

1. Change the Content-Type : "text/html"
2. Build an HTML page

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
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
			res.put_string (web_page)
		end


	web_page: STRING = "[ 	
	<!DOCTYPE html>
	<html>
		<head>
			<title>Resume</title>
		</head>
		<body>
			Hello World
		</body>
	</html>
]"

end
```
##### Source code
The source code is available on Github. You can get it by running the command:

```git clone https://github.com/EiffelWebFramework/ewf_examples.git```

The example of the service that generates HTML is located in the directory $PATH/ewf_examples/workbook/basics/simple_html, where $PATH is where you run ```git clone``` . Just double click on the simple_html.ecf file and select the simple_html_nino target or if you prefer the command line, run the command:

```estudio -config simple_html.ecf -target simple_html_nino```

Nav: [Workbook](../workbook.md) |  [Handling Requests: Form/Query Parameter](/workbook/handling_request/form.md)

