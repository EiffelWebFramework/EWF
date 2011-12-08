Restbuck Eiffel Implementation based on the book of REST in Practice
====================================================================
This is an implementation of CRUD pattern for manipulate resources
<table>
<TR><TH>Verb</TH>         <TH>URI or template</TH>     <TH>Use</TH></TR>
<TR><TD>POST</TD>         <TD>/order</TD>              <TD>Create a new order, and upon success, receive a Locationheader specifying the new order's URI.</TD></TR>
<TR><TD>GET</TD>          <TD>/order/{orderId}</TD>    <TD>Request the current state of the order specified by the URI.</TD></TR>
<TR><TD>PUT</TD>          <TD>/order/{orderId}</TD>    <TD>Update an order at the given URI with new information, providing the full representation.</TD></TR>
<TR><TD>DELETE</TD>       <TD>/order/{orderId}</TD>    <TD>Logically remove the order identified by the given URI.</TD></TR>
</table>

How to Create an order

    * Uri: http://localhost:8080/order
    * Method: POST
    * Note: you will get in the response the "location" of the new your order.
    * HEADERS:

      Content-Type: application/json

    * Example CONTENT
	     
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



How to Read an order
    * Uri: http://localhost:8080/order/{order_id}
    * Method: GET




How to Update an order
    * Uri: http://localhost:8080/order/{order_id}
    * Method: PUT


How to Delete an order
    * Uri: http://localhost:8080/order/{order_id}
    * Method: DELETE

