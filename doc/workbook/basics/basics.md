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

The following code describes the basic structure of an EWF basic service that handles HTTP requests. We will need to define a Service Launcher and a Request Execution implementation. 

```eiffel
class
    APPLICACTION

inherit
    WSF_DEFAULT_SERVICE [APPLICATION_EXECUTION] 

create
    make_and_launch

end
```

The class ```APPLICATION``` inherit from 
```WSF_DEFAULT_SERVICE [G ->WSF_EXECUTION create make end]``` it will be responsible to launch the service an set optional options.

The class ```APPLICATION_EXECUTION``` is an implementation ```WSF_EXECUTION``` interface, which is instantiated for each incoming request.

```eiffel
class
    APPLICATION_EXECUTION

inherit
    WSF_EXECUTION

create
    make

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

When using the "nino" connector or the new "standalone" connector, by default the service listens on port 80, but often this port is already used by other applications, so it is recommended to use another port.
To define another port, redefine the feature `initialize' and set up a new port number using the service options (see below).


```eiffel
class
    APPLICATION

inherit
    WSF_DEFAULT_SERVICE [APPLICATION_EXECUTION] 
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
end
```

The **WSF_REQUEST** gives access to the incoming data; the class provides features to get information such as request method, form data, query parameters, uploaded files, HTTP request headers, and hostname of the client among others. 
The **WSF_RESPONSE** provides features to define the response with information such as HTTP status codes (10x,20x, 30x, 40x, and 50x), response headers (Content-Type, Content-Length, etc.) and obviously the body of the message itself.

**APPLICATION** is the root class of our example, it launches the application, using the corresponding connector, Which connector? this depends how you want to run it cgi, fcgi, or standalone. For development is recommended to use a standalone web server written in Eiffel, and run the execution within the EiffelStudio debugger. For production fcgi (or cgi) using Apache or another popular web server.

The **APPLICATION_EXECUTION** class inherits from _WSF_EXECUTION_ interface,  which is instantiated for each incoming request. Let’s describe them in a few words.

![Execution Hierarchy](/doc/workbook/basic/APPLICATION_EXECUTION.png "Application ExecUtion ")

**WS_LAUNCHABLE_SERVICE** inherit from **WS_SERVICE** class, which is the low level entry point in EWF, handling each incoming request with a single procedure ```execute (req: WSF_REQUEST; res: WSF_RESPONSE) ...```. And also provides a way to launch our application using different kind of connectors. Below a [BON diagram] (http://www.bon-method.com/index_normal.htm) showing the different kind of connectors.

![Launcher Hierarchy](/doc/workbook/basic/Launcher Hierarchy.png "Launcher Hierarchy")

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

