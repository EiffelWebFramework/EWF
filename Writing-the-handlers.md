# Writing the handlers

Now you have to implement each handler. You need to inherit from WSF_SKELETON_HANDLER (as ORDER_HANDLER does). This involves implementing a lot of deferred routines. There are other routines for which default implementations are provided, which you might want to override. This applies to both routines defined in this class, and those declared in the three policy classes from which it inherits.

## Implementing the routines declared directly in WSF_SKELETON_HANDLER

### is_chunking

HTTP/1.1 supports streaming responses (and providing you have configured your server to use a proxy server in WSF_PROXY_USE_POLICY, this framework guarantees you have an HTTP/1.1 client to deal with). It is up to you whether or not you choose to make use of it. If so, then you have to serve the response one chunk at a time (but you could generate it all at once, and slice it up as you go). In this routine you just say whether or not you will be doing this. So the framework n=knows which other routines to call.

## includes_response_entity

The response to a DELETE, PUT or POST will include HTTP headers. It may or may not include a body. It is up to you, and this is where you tell the framework.

## conneg

[The HTTP/1.1 specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.1) defines server-driven content negotiation. Based on the Accept* headers in the request, we can determine whether we have a format for the response entity that is acceptable to the client. You need to indicate what formats you support. The framework does the rest. Normally you will have the same options for all requests, in which case you can use a once object.

## mime_types_supported

Here you need to indicate which media types you support for responses. One of the entries must be passed to the creation routine for conneg.

## languages_supported

Here you need to indicate which languages you support for responses. One of the entries must be passed to the creation routine for conneg.


## charsets_supported

Here you need to indicate which character sets you support for responses. One of the entries must be passed to the creation routine for conneg.


## encodings_supported

Here you need to indicate which compression encodings you support for responses. One of the entries must be passed to the creation routine for conneg.

## additional_variant_headers

The framework will write a Vary header if conneg indicates that different formats are supported. This warns caches that they may not be able to use a cached response if the Accept* headers in the request differ. If the author knows that the response may be affected by other request headers in addition to these, then they must be indicated here, so they can be included in a Vary header with the response.

## predictable_response

If the response may vary in other ways not predictable from the request headers, then redefine this routine to return True. In that case we will generate a Vary: * header to inform the cache that the response is not necessarily repeatable.

## matching_etag

An **ETag** header is a kind of message digest. Clients can use etags to avoid re-fetching responses for unchanged resources, or to avoid updating a resource that may have changed since the client last updated it.
You must implement this routine to test for matches **if and only if** you return non-Void responses for the etag routine. 

## etag

You are strongly encouraged to return non-Void for this routine. See [Validation Model](http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.3) for more details.

## modified_since

You need to implement this. If you do not have information about when a resource was last modified, then return True as a precaution. Of course, you return false for a static resource.

## treat_as_moved_permanently

This routine when a PUT request is made to a resource that does not exist. See [PUT](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.6) in the HTTP/1.1 specification for why you might want to return zero.

## Implementing the policies

* [WSF_OPTIONS_POLICY](./WSF_OPTIONS_POLICY)
* [WSF_PREVIOUS_POLICY](./WSF_PREVIOUS_POLICY)
* [WSF_CACHING_POLICY](./WSF_CACHING_POLICY)