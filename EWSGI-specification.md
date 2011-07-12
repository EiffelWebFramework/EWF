**WARNING** **THIS PAGE IS IN PROGRESS, AS IT IS NOW, IT NEEDS UPDATE SINCE IT DOES NOT REFLECT THE FUTURE INTERFACE**

# The Eiffel Web Server Gateway Interface
## Preface 

This document specifies a proposed standard interface between web servers and Eiffel web applications or frameworks, to promote web application portability across a variety of web servers.

Note: This document is based on  [PEP 333](http://www.python.org/dev/peps/pep-0333/) -- Python Web Server Gateway Interface v1.0 but adapted to needs and properties of Eiffel.

## Rationale and Goals
The most important goal of EWSGI is to enable an amazingly simple and wonderful programmer experience to the Eiffel developer who wants to write Eiffel server applications for the web!

Other programming laguages like Java boast a wide variety of web application frameworks. Java's "servlet" API makes it possible for applications written with any Java web application framework to run in any web server that supports the servlet API. Python also boasts many frameworks like Zope, Quixote, Webware, SkunkWeb, PSO, and Twisted Web -- to name just a few. This wide variety of choices was a problem for new Python users, because there was no standard protocol or convention for how webservers were to interact with Python applications and frameworks and this meant that the frameworks only worked with some webservers and not with others. To resolve this the  [PEP 333](http://www.python.org/dev/peps/pep-0333/) -- Python Web Server Gateway Interface v1.0 was written and subsequently implemented in many webserver environments and in Python frameworks.

The availability and widespread use of such an API in web servers for Eiffel -- whether those servers are written in Eiffel (e.g. Niño), embed Eiffel in Apache (e.g. mod_eiffel), or invoke Eiffel via a gateway protocol (e.g. CGI, FastCGI, etc.) -- would separate choice of framework from choice of web server, freeing users to choose a pairing that suits them, while freeing server developers as well as developers of higher level web application framworks and tools, like AJC (Alex's Eiffel2JavaScript), to focus on their preferred area of specialization.

This document, therefore, proposes a simple and universal interface between web servers and Eiffel web applications and frameworks: the Eiffel Web Server Gateway Interface (EWSGI).

But the mere existence of a EWSGI spec does nothing to address the existing state of servers and frameworks for Eiffel web applications. Server and framework authors and maintainers must actually implement EWSGI for there to be any effect.

However, since no existing servers or frameworks support EWSGI, there is little immediate reward for an author who implements EWSGI support. Thus, EWSGI must be easy to implement, so that an author's initial investment in the interface can be reasonably low.

Thus, simplicity of implementation on both the server and framework sides of the interface is absolutely critical to the utility of the EWSGI interface, and is therefore the principal criterion for any design decisions.

Note, however, that simplicity of implementation for a framework author is not the same thing as ease of use for a web application author. EWSGI presents an absolutely "no frills" interface to the framework author, because bells and whistles like response objects and cookie handling would just get in the way of existing frameworks' handling of these issues. Again, the goal of EWSGI is to facilitate easy interconnection of existing servers and applications or frameworks, not to create a new web framework.

## Proof-of-concept and reference implementation

We propose a proof-of-concept or reference implementation be done with:

* CGI
* FCGI
* Nino. A simple Web server written in Eiffel by Javier Velilla.
* mod_ewsgi. Apache module on Linux and Windows using Wamie.

The reference implementation should enable a user to write an EWSGI "Hello World" application:

1. Using just 1 Eiffel class of ~10 lines of code.
1. And easily switch deployment method (CGI, FCGI, Nino or mod_ewsgi).

A reference implementation is being worked on by Jocelyn Fiat (Eiffel Software), Javier Velilla (independent), Daniel Rodríguez (Seibo) and Paul Cohen (Seibo). The reference implementation consists of

1. EWSGI core library:  [Eiffel-WebFramework](https://github.com/Eiffel-World/Eiffel-Web-Framework).
1. eJSON library:  [eJSON](http://ejson.origo.ethz.ch/).
1. Nino Eiffel Web server:  [Nino](http://code.google.com/p/webeiffel/source/browse/#svn%2Ftrunk%2Feiffelwebnino).
1. mod_ewsgi module. Based on [Wamie](http://eiffel.seibostudios.se/wiki/Wamie).
1. SOS. Simple Object Storage - a simple Eiffel persistance mechanism.

# Specification overview

## The Server/Gateway Side

This is the web server side. The server sends the request information in an environment object or structure to the Application/Framework side and expects information on what to return in the form of a response object.

## The Application/Framework Side

This is the Eiffel application side. Basically one should be able to write:

      class APPLICATION
      inherit
	  EW_APPLICATION
      creation
	  make  - - THIS IS PART OF THE EWSGI SPECIFICATION!
      features
	  execute (env: ENVIRON): RESPONSE is - - THIS IS PART OF THE EWSGI SPECIFICATION!
	  do
		create Result
		if env.path_info = ”/hello” then
			Result.set_status (Http_ok)
			Result.set_header (”Content-Type”, ”text/html; charset=utf-8”)
			Result.put_contents (”<html><body>Hello World</body></html>”)
		else
			Result.set_status (Http_not_found)
		end
	  end
      end

Or to register handlers for specific URL paths (or regexp based URL path expressions):

    class APPLICATION
    inherit
	 EW_APPLICATION
    creation
	 make
    redefine
	 make
    features
	
	 make is
		do
			register_handler (”/hello”, ~hello_world_handler)
			-- The default execute feature will dispatch calls to the appropriate handler!
		end

	 hello_world_handler (env: ENVIRON): RESPONSE is
		do
			create Result
			if env.path_info = ”/hello” then
				Result.set_status (Http_ok)
				Result.set_header (”Content-Type”, ”text/html; charset=utf-8”)
				Result.put_contents (”<html><body>Hello World</body></html>”)
			else
				Result.set_status (Http_notund)
			end
		end
	 e ¶nd
    end

## Specification Details

Required information in the ENVIRONMENT class.

The ENVIRONMENT class is required to provide features for accesing CGI environment variables, as defined by the  Common Gateway Interface specification. The following variables must be present.
Variable 	Description
auth_type: STRING 	"Basic", "Digest" or some other token.
request_method: STRING 	The HTTP request method, such as "GET" or "POST".
script_name: STRING 	The initial portion of the request URL's "path" that corresponds to the application object, so that the application knows its virtual "location". This may be an empty string, if the application corresponds to the "root" of the server.
path_info: STRING 	The remainder of the request URL's "path", designating the virtual "location" of the request's target within the application. This may be an empty string, if the request URL targets the application root and does not have a trailing slash.
query_string: STRING 	The portion of the request URL that follows the "?", if any.
content_type: STRING 	The contents of any Content-Type fields in the HTTP request. May be empty.
content_length: STRING 	The contents of any Content-Length fields in the HTTP request. May be empty.
server_name, server_port: STRING 	When combined with script_name and path_info, these variables can be used to complete the URL. Note, however, that HTTP_HOST, if present, should be used in preference to server_name for reconstructing the request URL. See the URL Reconstruction section below for more detail. server_name and server_port can never be empty strings.
server_protocol: STRING 	The version of the protocol the client used to send the request. Typically this will be something like "HTTP/1.0" or "HTTP/1.1" and may be used by the application to determine how to treat any HTTP request headers. (This variable should probably be called request_protocol, since it denotes the protocol used in the request, and is not necessarily the protocol that will be used in the server's response. However, for compatibility with CGI we have to keep the existing name.)
http_variables: HASH_TABLE [STRING, STRING] 	Variables corresponding to the client-supplied HTTP request headers (i.e., variables whose names begin with "HTTP_"). The presence or absence of these variables should correspond with the presence or absence of the appropriate HTTP header in the request.

Required information in the RESPONSE class.
Implementation/Application Notes ¶

For an Eiffel system to run it needs to be compiled to a executable program or shared library (.so/.dll). For supporting CGI all that is needed is an executable program, For FCGI and EWSGI we need to compile the Eiffel system to a shared library.
Questions and Answers ¶
Proposed/Under Discussion ¶
Acknowledgements ¶
References ¶