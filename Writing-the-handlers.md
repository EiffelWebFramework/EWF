# Writing the handlers

Now you have to implement each handler. You need to inherit from WSF_SKELETON_HANDLER (as ORDER_HANDLER does). This involves implementing a lot of deferred routines. There are other routines for which default implementations are provided, which you might want to override. This applies to both routines defined in this class, and those declared in the three policy classes from which it inherits.

## Implementing the routines declared directly in WSF_SKELETON_HANDLER

### is_chunking

HTTP/1.1 supports streaming responses (and providing you have configured your server to use a proxy server in WSF_PROXY_USE_POLICY, this framework guarantees you have an HTTP/1.1 client to deal with). It is up to you whether or not you choose to make use of it. If so, then you have to serve the response one chunk at a time (but you could generate it all at once, and slice it up as you go). In this routine you just say whether or not you will be doing this. So the framework n=knows which other routines to call.

## includes_response_entity

The response to a DELETE, PUT or POST will include HTTP headers. It may or may not include a body. It is up to you, and this is where you tell the framework.

## conneg

[The HTTP/1.1 specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.1) defines server-driven content negotiation. Based on the Accept* headers in the request, we can determine whether we have a format for the response entity that is acceptable to the client. You need to indicate what formats you support. The framework does the rest. Normally you will have the same options for all requests, in which case you can use a once object.

## Implementing the policies

* [WSF_OPTIONS_POLICY](./WSF_OPTIONS_POLICY)
* [WSF_PREVIOUS_POLICY](./WSF_PREVIOUS_POLICY)
* [WSF_CACHING_POLICY](./WSF_CACHING_POLICY)
