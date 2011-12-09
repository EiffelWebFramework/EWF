Restbuck Eiffel Implementation based on the book of REST in Practice
====================================================================
This is an ihmplementation of CRUD pattern for manipulate resources, this is the first step to use
the HTTP protocol as an application protocol instead of a transport protocol.

Restbuck Protocol
-----------------

<table>
<TR><TH>Verb</TH>         <TH>URI or template</TH>     <TH>Use</TH></TR>
<TR><TD>POST</TD>         <TD>/order</TD>              <TD>Create a new order, and upon success, receive a Locationheader specifying the new order's URI.</TD></TR>
<TR><TD>GET</TD>          <TD>/order/{orderId}</TD>    <TD>Request the current state of the order specified by the URI.</TD></TR>
<TR><TD>PUT</TD>          <TD>/order/{orderId}</TD>    <TD>Update an order at the given URI with new information, providing the full representation.</TD></TR>
<TR><TD>DELETE</TD>       <TD>/order/{orderId}</TD>    <TD>Logically remove the order identified by the given URI.</TD></TR>
</table>

Resource Represenation
----------------------
The previous tables shows a contrat, the URI or URI template, allows us to indentify resources, now we will chose a 
representacion, for this particular case we will use JSON.

Note: <br/>
1. *A resource can have multiple URIs*.<br/>
2. *A resource can have multiple Representations*.<br/>

RESTBUCKS_SERVER
----------------
This class implement the main entry of our REST CRUD service, we are using a default connector (Nino Connector, 
using a WebServer written in Eiffel).
We are inheriting from URI_TEMPLATE_ROUTED_SERVICE, this allows us to map our service contrat, as is shown in the previous
table, the mapping is defined in the feature setup_router, this also show that the class ORDER_HANDLER will be encharge
of to handle different type of request to the ORDER resource.


	class
		RESTBUCKS_SERVER
	
	inherit
		ANY
	
		URI_TEMPLATE_ROUTED_SERVICE
	
		DEFAULT_SERVICE
			-- Here we are using a default connector using the default Nino Connector,
			-- but it's possible to use other connector (CGI or FCGI).
	
	create
		make
	
	feature {NONE} -- Initialization
	
		make
			-- Initialize the router (this will have the request handler and 
			-- their context).
			do
				initialize_router
				make_and_launch
			end
	
		create_router
			do
				create router.make (2)
			end
	
		setup_router
			local
				order_handler: ORDER_HANDLER [REQUEST_URI_TEMPLATE_HANDLER_CONTEXT]
			do
				create order_handler
				router.map_with_request_methods ("/order", order_handler, <<"POST">>)
				router.map_with_request_methods ("/order/{orderid}", order_handler, <<"GET", "DELETE", "PUT">>)
			end
	
	feature -- Execution
	
		execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
				-- I'm using this method to handle the method not allowed response
				-- in the case that the given uri does not have a corresponding http method
				-- to handle it.
			local
				h : HTTP_HEADER
				l_description : STRING
				l_api_doc : STRING
			do
				if req.content_length_value > 0 then
					req.input.read_string (req.content_length_value.as_integer_32)
				end
				create h.make
				h.put_status ({HTTP_STATUS_CODE}.method_not_allowed)
				h.put_content_type_text_plain
				l_api_doc := "%NPlease check the API%NURI:/order METHOD: POST%NURI:/order/{orderid} METHOD: GET, PUT, DELETE%N"
				l_description := req.request_method + req.request_uri + " is not allowed" + "%N" + l_api_doc
				h.put_content_length (l_description.count)
				h.put_current_date
				res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
				res.write_header_text (h.string)
				res.write_string (l_description)
			end
	
	end



How to Create an order with POST
--------------------------------

Here is the convention that we are using: 
POST is used for creation and the server determines the URI of the created resource.
If the request POST is SUCCESS, the server will create the order and will response with
201 CREATED, the Location header will contains the newly created order's URI,
if the request POST is not SUCCESS, the server will response with
400 BAD REQUEST, the client send a bad request or
500 INTERNAL_SERVER_ERROR, when the server can deliver the request.

POST /order HTTP/1.1
Host: 127.0.0.1:8080
Connection: keep-alive
Content-Length: 196
Origin: chrome-extension://fhjcajmcbmldlhcimfajhfbgofnpcjmb
Content-Type: application/json
Accept: */*
Accept-Encoding: gzip,deflate,sdch
Accept-Language: es-419,es;q=0.8,en;q=0.6
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3
	     
{
 "location":"takeAway",
 "items":[
          {
           "name":"Late",
	   "option":"skim",
	   "size":"Small",
	   "quantity":1
	   }
    ]
}

Response success

HTTP/1.1 201 Created
Status	201 Created
Content-Type	application/json
Content-Length	123
Location	http://localhost:8080/order/1
Date	FRI,09 DEC 2011 20:34:20.00 GMT

{
  "id" : "1",
  "location" : "takeAway",
  "status" : "submitted",
  "items" : [ {
    "name" : "late",
    "size" : "small",
    "quantity" : 1,
    "option" : "skim"
  } ]
}


How to Read an order
--------------------
    * Uri: http://localhost:8080/order/{order_id}
    * Method: GET




How to Update an order
----------------------
    * Uri: http://localhost:8080/order/{order_id}
    * Method: PUT


How to Delete an order
----------------------
    * Uri: http://localhost:8080/order/{order_id}
    * Method: DELETE


References
----------
1. [How to get a cup of coffe](http://www.infoq.com/articles/webber-rest-workflow) 
2. [Rest in Practice] (http://restinpractice.com/default.aspx)
