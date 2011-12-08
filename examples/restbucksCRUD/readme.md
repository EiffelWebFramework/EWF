Restbuck Eiffel Implementation based on the book of REST in Practice

This is an implementation of CRUD web services as is presented in the book

Verb         URI or template     Use
POST         /order              Create a new order, and upon success, receive a Locationheader specifying the new order’s URI.
GET          /order/{orderId}    Request the current state of the order specified by the URI.
PUT          /order/{orderId}    Update an order at the given URI with new information, providing the full representation.
DELETE       /order/{orderId}    Logically remove the order identified by the given URI.


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

