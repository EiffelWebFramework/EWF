note
	description: "Based on http://en.wikipedia.org/wiki/List_of_HTTP_status_codes."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_RESPONSE_STATUS_CODES

feature -- 1xx Informational

	Continue : INTEGER = 100
		--This means that the server has received the request headers, and that the client should proceed to send the request body
		--(in the case of a request for which a body needs to be sent; for example, a POST request).
		--If the request body is large, sending it to a server when a request has already been rejected based upon inappropriate headers is inefficient.
		--To have a server check if the request could be accepted based on the request's headers alone,
		--a client must send Expect: 100-continue as a header in its initial request[2] and check if a 100 Continue status code is received in response
		--before continuing (or receive 417 Expectation Failed and not continue).

	Switching_Protocols : INTEGER = 101
		--This means the requester has asked the server to switch protocols and the server is acknowledging that it will do so.

	Processing : INTEGER = 102  -- (WebDAV) (RFC 2518)	
		--As a WebDAV request may contain many sub-requests involving file operations, it may take a long time to complete the request.
		--This code indicates that the server has received and is processing the request, but no response is available yet.
		--This prevents the client from timing out and assuming the request was lost.

	Checkpoint : INTEGER = 103
		--This code is used in the Resumable HTTP Requests Proposal to resume aborted PUT or POST requests.

	Request_URI_too_long_ie7 : INTEGER = 122
		--This is a non-standard IE7-only code which means the URI is longer than a maximum of 2083 characters


feature -- 2xx Success

	OK : INTEGER = 200
		--Standard response for successful HTTP requests. The actual response will depend on the request method used.
		--In a GET request, the response will contain an entity corresponding to the requested resource.
		--In a POST request the response will contain an entity describing or containing the result of the action.

	Created : INTEGER = 201
		--The request has been fulfilled and resulted in a new resource being created.

	Accepted : INTEGER = 202
		--The request has been accepted for processing, but the processing has not been completed.
		--The request might or might not eventually be acted upon, as it might be disallowed when processing actually takes place.

	Non_Authoritative_Information : INTEGER = 203  --(since HTTP/1.1)
		--The server successfully processed the request, but is returning information that may be from another source.

	No_Content : INTEGER = 204
		--The server successfully processed the request, but is not returning any content.

	Reset_Content : INTEGER = 205
		--The server successfully processed the request, but is not returning any content.
		--Unlike a 204 response, this response requires that the requester reset the document view.


	Partial_Content : INTEGER = 206
		--The server is delivering only part of the resource due to a range header sent by the client.
		--The range header is used by tools like wget to enable resuming of interrupted downloads,
		--or split a download into multiple simultaneous streams.

	Multi_Status : INTEGER = 207 --(WebDAV) (RFC 4918)
		--The message body that follows is an XML message and can contain a number of separate response codes,
		-- depending on how many sub-requests were made.

	IM_Used : INTEGER = 226 -- (RFC 3229)
		--The server has fulfilled a GET request for the resource, and the response is a representation of the result of one
		--or more instance-manipulations applied to the current instance.

feature -- 3xx Redirection


 	Multiple_Choices : INTEGER = 300
		--Indicates multiple options for the resource that the client may follow.
		--It, for instance, could be used to present different format options for video, list files with different extensions, or word sense disambiguation.

	Moved_Permanently : INTEGER = 301
		--This and all future requests should be directed to the given URI.

	Found : INTEGER = 302
		--This is an example of industrial practice contradicting the standard.
		--HTTP/1.0 specification (RFC 1945) required the client to perform a temporary redirect (the original describing phrase was "Moved Temporarily"),
		--but popular browsers implemented 302 with the functionality of a 303 See Other.
		--Therefore, HTTP/1.1 added status codes 303 and 307 to distinguish between the two behaviours.
		--However, some Web applications and frameworks use the 302 status code as if it were the 303.

	See_Other : INTEGER = 303 -- (since HTTP/1.1)
		--The response to the request can be found under another URI using a GET method.
		--When received in response to a POST (or PUT/DELETE), it should be assumed that the server
		--has received the data and the redirect should be issued with a separate GET message.

	Not_Modified : INTEGER = 304
		--Indicates the resource has not been modified since last requested.
		--Typically, the HTTP client provides a header like the If-Modified-Since header to provide a time against which to compare.
		--Using this saves bandwidth and reprocessing on both the server and client,
		--as only the header data must be sent and received in comparison to the entirety of the page being re-processed by the server,
		--then sent again using more bandwidth of the server and client.

	Use_Proxy : INTEGER = 305 --(since HTTP/1.1)
		--Many HTTP clients (such as Mozilla and Internet Explorer) do not correctly handle responses with this status code, primarily for security reasons.

	Switch_Proxy : INTEGER = 306
		--No longer used. Originally meant "Subsequent requests should use the specified proxy."

	Temporary_Redirect : INTEGER = 307 --(since HTTP/1.1)
		--In this occasion, the request should be repeated with another URI, but future requests can still use the original URI.
		--In contrast to 303, the request method should not be changed when reissuing the original request.
		--For instance, a POST request must be repeated using another POST request.

	Resume_Incomplete : INTEGER = 308
		--This code is used in the Resumable HTTP Requests Proposal to resume aborted PUT or POST requests.	

feature -- 4xx Client Error

	Bad_Request : INTEGER = 400
		--The request cannot be fulfilled due to bad syntax.

	Unauthorized : INTEGER = 401
		--Similar to 403 Forbidden, but specifically for use when authentication is possible but has failed or not yet been provided.
		--The response must include a WWW-Authenticate header field containing a challenge applicable to the requested resource.
		--See Basic access authentication and Digest access authentication.

	Payment_Required : INTEGER = 402
		--Reserved for future use.The original intention was that this code might be used as part of some form of digital cash or micropayment scheme,
		--but that has not happened, and this code is not usually used.
		--As an example of its use, however, Apple's MobileMe service generates a 402 error ("httpStatusCode:402" in the Mac OS X Console log) if the MobileMe account is delinquent.

	Forbidden : INTEGER = 403
		--The request was a legal request, but the server is refusing to respond to it.
		--Unlike a 401 Unauthorized response, authenticating will make no difference.

	Not_Found : INTEGER = 404
		--The requested resource could not be found but may be available again in the future.
		--Subsequent requests by the client are permissible.

	Method_Not_Allowed : INTEGER = 405
		--A request was made of a resource using a request method not supported by that resource;
		--for example, using GET on a form which requires data to be presented via POST, or using PUT on a read-only resource.

	Not_Acceptable : INTEGER = 406
		--The requested resource is only capable of generating content not acceptable according to the Accept headers sent in the request.

	Proxy_Authentication_Required : INTEGER = 407
		--The client must first authenticate itself with the proxy.

	Request_Timeout : INTEGER = 408
		--The server timed out waiting for the request. According to W3 HTTP specifications:
		--"The client did not produce a request within the time that the server was prepared to wait. The client MAY repeat the request without modifications at any later time."

	Conflict : INTEGER = 409
		--Indicates that the request could not be processed because of conflict in the request, such as an edit conflict.

	Gone : INTEGER = 410
		--Indicates that the resource requested is no longer available and will not be available again.
		--This should be used when a resource has been intentionally removed and the resource should be purged.
		-- Upon receiving a 410 status code, the client should not request the resource again in the future.
		-- Clients such as search engines should remove the resource from their indices.
		--Most use cases do not require clients and search engines to purge the resource, and a "404 Not Found" may be used instead.

	Length_Required : INTEGER = 411
		--The request did not specify the length of its content, which is required by the requested resource.

	Precondition_Failed : INTEGER = 412
		--The server does no t meet one of the preconditions that the requester put on the request.

	Request_Entity_Too_Large : INTEGER = 413
		--The request is larger than the server is willing or able to process.

	Request_URI_Too_Long : INTEGER = 414
		--The URI provided was too long for the server to process.

	Unsupported_Media_Type : INTEGER = 415
		--The request entity has a media type which the server or resource does not support.
		--For example, the client uploads an image as image/svg+xml, but the server requires that images use a different format.

	Requested_Range_Not_Satisfiable : INTEGER = 416
		--The client has asked for a portion of the file, but the server cannot supply that portion.
		--For example, if the client asked for a part of the file that lies beyond the end of the file.

	Expectation_Failed : INTEGER = 417
		--The server cannot meet the requirements of the Expect request-header field.

	Im_a_teapot : INTEGER = 418 --(RFC 2324)
		--This code was defined in 1998 as one of the traditional IETF April Fools' jokes, in RFC 2324,
		--Hyper Text Coffee Pot Control Protocol, and is not expected to be implemented by actual HTTP servers.

	Unprocessable_Entity : INTEGER = 422 --(WebDAV) (RFC 4918)
		--The request was well-formed but was unable to be followed due to semantic errors.

	Locked : INTEGER = 423 --(WebDAV) (RFC 4918)
		--The resource that is being accessed is locked.

	Failed_Dependency : INTEGER = 424 --(WebDAV) (RFC 4918)
		--The request failed due to failure of a previous request (e.g. a PROPPATCH).

	Unordered_Collection : INTEGER = 425 --(RFC 3648)
		--Defined in drafts of "WebDAV Advanced Collections Protocol",
		--but not present in "Web Distributed Authoring and Versioning (WebDAV) Ordered Collections Protocol".

	Upgrade_Required : INTEGER = 426 -- (RFC 2817)
		--The client should switch to a different protocol such as TLS/1.0.

	No_Response : INTEGER = 444
		--A Nginx HTTP server extension. The server returns no information to the client and closes the connection (useful as a deterrent for malware).

	Retry_With : INTEGER = 449
		--A Microsoft extension. The request should be retried after performing the appropriate action.

	Blocked_by_Windows_Parental_Controls : INTEGER = 450
		--A Microsoft extension. This error is given when Windows Parental Controls are turned on and are blocking access to the given webpage.

	Client_Closed_Request : INTEGER = 499
		--An Nginx HTTP server extension.
		--This code is introduced to log the case when the connection is closed by client while HTTP server is processing its request,
		-- making server unable to send the HTTP header back.

feature -- 5xx Server Error
	Internal_Server_Error : INTEGER = 500
		--A generic error message, given when no more specific message is suitable.

	Not_Implemented : INTEGER = 501
		--The server either does not recognise the request method, or it lacks the ability to fulfill the request.

	Bad_Gateway : INTEGER = 502
		--The server was acting as a gateway or proxy and received an invalid response from the upstream server.

	Service_Unavailable : INTEGER = 503
		--The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state.

	Gateway_Timeout : INTEGER = 504
		--The server was acting as a gateway or proxy and did not receive a timely response from the upstream server.

	HTTP_Version_Not_Supported : INTEGER = 505
		--The server does not support the HTTP protocol version used in the request.

	Variant_Also_Negotiates : INTEGER = 506 --(RFC 2295)
		--Transparent content negotiation for the request results in a circular reference.

	Insufficient_Storage : INTEGER = 507 -- (WebDAV)(RFC 4918)	
		--The server is unable to store the representation needed to complete the request.

	Bandwidth_Limit_Exceeded : INTEGER = 509 -- (Apache bw/limited extension)
		--This status code, while used by many servers, is not specified in any RFCs.

	Not_Extended : INTEGER = 510 -- (RFC 2774)
		--Further extensions to the request are required for the server to fulfill it.[20]

	network_read_timeout_error : INTEGER = 598 --598 (Informal convention)
		--This status code is not specified in any RFCs, but is used by some HTTP proxies to signal a network read
		--timeout behind the proxy to a client in front of the proxy.

	network_connect_timeout_error : INTEGER = 599
		--This status code is not specified in any RFCs, but is used by some HTTP proxies to signal a
		--network connect timeout behind the proxy to a client in front of the proxy.
end
