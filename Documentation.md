# Current Status 
* Official repository: <https://github.com/EiffelWebFramework/EWF>
* Official website: <http://eiffelwebframework.github.io/EWF/getting-started/>

# What is EWF?

Eiffel Web Framework, is mainly a collection of Eiffel libraries designed to be integrated with each other. One benefit is that it supports all core HTTP features, so enable you embrace HTTP as an application protocol to develop web applications. So you do not need to adapt your applications to the web, instead you use the web power. It means you can build different kind of web applications, from Web APIs following the Hypermedia API style (REST style), CRUD web services or just conventional web applications building a session on top of an stateless protocol. 

# EWF core/kernel
_ The Web Server Foundation (WSF\_) is the core of the framework. It is compliant with the EWSGI interface (WGI\_). _

To build a web [service](#service), the framework provides a set of core components to launch the service, for each [request](#request-and-response), access the data, and send the [response](#request-and-response). 
The framework also provides a router component to help dispatching the incoming request.

A service can be a web api, a web interface, … what ever run on top of HTTP.

<a name="wiki-service"/>
# Service
_ see interface: **WSF_SERVICE** _

Each incoming http request is processed by the following routine.

> `{WSF_SERVICE}.execute (req: WSF_REQUEST; res: WSF_RESPONSE)`

This is the low level of the framework, at this point, `req’ provides access to the query and form parameters, input data, headers, … as specified by the Common Gateway Interface (CGI).
The response `res’ is the interface to send data back to the client.
For convenience, the framework provides richer service interface that handles the most common needs (filter, router, …).

<a name="wiki-request"/><a name="wiki-response"/><a name="wiki-request-and-response"/>
# Request and Response
_ see interface: **WSF_REQUEST** and **WSF_RESPONSE** _
Any incoming http request is represented by an new object of type **WSF_REQUEST**.

**WSF_REQUEST** provides access to
* meta variables: CGI variables (coming from the request http header)
* query parameters: from the uri ex: ?q=abc&type=pdf
* input data: the message of the request, if this is a web form, this is parsed to build the form parameters. It can be retrieved once.
* form parameters: standard parameters from the request input data.
  *typically available when a web form is sent using POST as content of type `multipart/form-data` or `application/x-www-form-urlencoded`
  *(advanced usage: it is possible to write mime handler that can processed other type of content, even custom format.)
* uploaded files: if files are uploaded, their value will be available from the form parameters, and from the uploaded files as well.
* cookies variable: cookies extracted from the http header.
* path parameters: note this is related to the router and carry the semantic of the mapping (see the section on router )
* execution variables: used by the application to keep value associated with the request.

The **WSF_RESPONSE** represents the communication toward the client, a service need to provide correct headers, and content. For instance the `Content-Type`, and `Content-Length`. It also allows to send data with chunked encoding.

{{Learn more}}

<a name="wiki-connector"/>
# Connectors: 
_see **WGI_CONNECTOR**_
Using EWF, your service is built on top of underlying httpd solution/connectors.
Currently 3 main connectors are availables:
CGI: following the CGI interface, this is an easy solution to run the service on any platform.
libFCGI: based on the libfcgi solution, this can be used with apache, IIS, nginx, … 
nino: a standalone server: Eiffel Web Nino allow you to embed a web server anywhere, on any platform without any dependencies on other httpd server.
At compilation time, you can use a default connector (by using the associated default lib), but you can also use a mixed of them and choose which one to execute at runtime.
It is fairly easy to add new connector, it just has to follow the EWSGI interface
Router or Request Dispatcher:
Routes HTTP requests to the proper execution code
A web application needs to have a clean and elegant URL scheme, and EWF provides a router component to design URLs.

The association between a URL pattern and the code handling the URL request is called a Router mapping in EWF.

EWF provides 3 main kinds of mappings
URI: any URL with path being the specified uri.
example: “/users/”  redirects any “/users/” and “/users/?query=...”
URI-template: any URL matching the specified URI-template
example: “/project/{name}/” redirects any “/project/foo” or “/project/bar” 
Starts-with: any URL starting with the specified path
Note: in the future, a Regular-Expression based kind will be added in the future, and it is possible to use custom mapping on top of EWF.

Code:
router.map ( create {WSF_URI_TEMPLATE_MAPPING}.make (
“/project/{name}”, project_handler) 
)
	-- And precising the request methods
router.map_with_request_methods ( … , router.methods_GET_POST)


In the previous code, the `project_handler’ is an object conforming to WSF_HANDLER, that will process the incoming requests matching URI-template “/project/{name}”.

Usually, the service will inherit from WSF_ROUTED_SERVICE, which has a `router’ attribute.
Configuring the URL scheme is done by implementing  `{WSF_ROUTED_SERVICE}.setup_router’.

To make life easier, by inheriting from WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_SERVICE, a few help methods are available to `map’ URI template with agent, and so on.
See 
map_uri_template (a_tpl: STRING; h: WSF_URI_TEMPLATE_HANDLER)
map_uri_template_agent (a_tpl: READABLE_STRING_8; proc: PROCEDURE [ANY, TUPLE [req: WSF_REQUEST; res: WSF_RESPONSE]])
and same with request methodes …
…
Check WSF_*_HELPER_FOR_ROUTED_SERVICE for other available helper classes.




How we do that in EWF? : Router with (or without context).
Related code: wsf_router,  wsf_router_context
Examples

EWF components 
URI Handler:
 Parses the details of the URI (scheme, path, query info, etc.) and exposes them for use.
How we do that in EWF?: URI Templates, but we could also use regex.
Related code: uri_template
Examples: 


Mime Parser/ Content Negotiation: 
Handles the details of determining the media type, language, encoding, compression (conneg). 
How do we do that in EWF? Content_Negotiation library.
Example


Request Handler
target of request dispatcher + uri handler. 
Here is where we handle GET, POST PUT, etc.

Representation Mapping
Converts stored data into the proper representation for responses and handles incoming representations from requests.

We don’t have a representation library, the developer need to do that.
If we want to provide different kind of representations: JSON, XML, HTML, the responsibility is let
to the developer to map their domain to the target representation. 

Http Client:
 A simple library to make requests and handle responses from other http servers.
How we do that in EWF? http client library
examples:

Authentication/Security: 
 Handle differents auth models. (Basic, Digest?, OAuth, OpenId)
How we do that in EWF? http_authorization, OpenId, and Cypress 
examples.

Caching:
 Support for Caching and conditional request
How we do that in Eiffel? Policy framework on top of EWF. {{{need_review}}}
examples 




EWF HTML5 Widgets

EWF policy Framework

EWF application generators



Specification
EWSGI



Libraries 

I’m including external libraries, like Cypress OAuth (Security),  HTML parsing library, Template Engine Smarty.


server
ewsgi: Eiffel Web Server Gateway Interface read more
connectors: various web server connectors for EWSGI
libfcgi: Wrapper for libfcgi SDK
wsf: Web Server Framework read more
router: URL dispatching/routing based on uri, uri_template, or custom read more
wsf_html: (html  and css) Content generator from the server side.
CMS example: https://github.com/EiffelWebFramework/cms/tree/master/example
protocol
http: HTTP related classes, constants for status code, content types, ... read more
uri_template: URI Template library (parsing and expander) read more
content_negotiation: CONNEG library (Content-type Negociation) read more
Client
http_client: simple HTTP client based on cURL readmore
Firebase API: https://github.com/EiffelWebFramework/Redwood 
Text
encoder: Various simpler encoders: base64, url-encoder, xml entities, html entities read more
Utils
error: very simple/basic library to handle error
Security
http_authentication (under EWF/library/server/authentication)
open_id (under EWF/library/security)
OAuth (https://github.com/EiffelWebFramework/cypress)
