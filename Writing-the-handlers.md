# Writing the handlers

Now you have to implement each handler. You need to inherit from WSF_SKELETON_HANDLER (as ORDER_HANDLER does). This involves implementing a lot of deferred routines. There are other routines for which default implementations are provided, which you might want to override. This applies to both routines defined in this class, and those declared in the three policy classes from which it inherits.

## Implementing the routines declared directly in WSF_SKELETON_HANDLER

### is_chunking

HTTP/1.1 supports streaming responses (and providing you have configured your server to use a proxy server in WSF_PROXY_USE_POLICY, this framework guarantees you have an HTTP/1.1 client to deal with). It is up to you whether or not you choose to make use of it. If so, then you have to serve the response one chunk at a time (but you could generate it all at once, and slice it up as you go). In this routine you just say whether or not you will be doing this. So the framework n=knows which other routines to call.
Currently we only support chunking for GET or HEAD routines. This might change in the future, so if you intend to return True, you should call req.is_get_head_request_method.

### includes_response_entity

The response to a DELETE, PUT or POST will include HTTP headers. It may or may not include a body. It is up to you, and this is where you tell the framework.

### conneg

[The HTTP/1.1 specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.1) defines server-driven content negotiation. Based on the Accept* headers in the request, we can determine whether we have a format for the response entity that is acceptable to the client. You need to indicate what formats you support. The framework does the rest. Normally you will have the same options for all requests, in which case you can use a once object.

### mime_types_supported

Here you need to indicate which media types you support for responses. One of the entries must be passed to the creation routine for conneg.

### languages_supported

Here you need to indicate which languages you support for responses. One of the entries must be passed to the creation routine for conneg.


### charsets_supported

Here you need to indicate which character sets you support for responses. One of the entries must be passed to the creation routine for conneg.


### encodings_supported

Here you need to indicate which compression encodings you support for responses. One of the entries must be passed to the creation routine for conneg.

### additional_variant_headers

The framework will write a Vary header if conneg indicates that different formats are supported. This warns caches that they may not be able to use a cached response if the Accept* headers in the request differ. If the author knows that the response may be affected by other request headers in addition to these, then they must be indicated here, so they can be included in a Vary header with the response.

### predictable_response

If the response may vary in other ways not predictable from the request headers, then redefine this routine to return True. In that case we will generate a Vary: * header to inform the cache that the response is not necessarily repeatable.

### matching_etag

An **ETag** header is a kind of message digest. Clients can use etags to avoid re-fetching responses for unchanged resources, or to avoid updating a resource that may have changed since the client last updated it.
You must implement this routine to test for matches **if and only if** you return non-Void responses for the etag routine. 

### etag

You are strongly encouraged to return non-Void for this routine. See [Validation Model](http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.3) for more details.

### modified_since

You need to implement this. If you do not have information about when a resource was last modified, then return True as a precaution. Of course, you return false for a static resource.

### treat_as_moved_permanently

This routine when a PUT request is made to a resource that does not exist. See [PUT](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.6) in the HTTP/1.1 specification for why you might want to return zero.

### allow_post_to_missing_resource

POST requests are normally made to an existing entity. However it is possible to create new resources using a POST, if the server allows it. This is where you make that decision.

If you return True, and the resource is created, a 201 Created response will be returned.

### content_length

If you are not streaming the result, the the HTTP protocol requires that the length of the entity is known. You need to implement this routine to provide that information.

### finished

If you are streaming the response, then you need to tell the framework when the last chunk has been sent.
To implement this routine, you will probably need to call req.set_execution_variable (some-name, True) in ensure_content_avaiable and generate_next_chunk, and call attached {BOOLEAN} req.execution_variable (some-name) in this routine.

### description

This is for the automatically generated documentation that the framework will generate in response to a request that you have not mapped into an handler.

### delete

This routine is for carrying out a DELETE request to a resource. If it is valid to delete the named resource, then you should either go ahead and do it, or queue a deletion request somewhere (if you do that then you will probably need to call req.set_execution_variable (some-name-or-other, True). Otherwise you should call req.error_handler.add_custom_error to explain why the DELETE could not proceed (you should also do this if the attempt to delete the resource fails).
Of course, if you have not mapped any DELETE requests to the URI space of this handler, then you can just do nothing.

### delete_queued

If in the delete routine, you elected to queue the request, then you need to return True here. You will probably need to check the execution variable you set in the delete routine.

### ensure_content_available

This routine is called for GET and DELETE (when a entity is provided in the response) processing. It's purpose is to make the text of the entity (body of the response) available for future routines (if is_chunking is true, then only the first chunk needs to be made available, although if you only serve, as opposed to generate, the result in chunks, then you will make the entire entity available here). This is necessary so that we can compute the length before we start to serve the response. You would normally save it in an execution variable on the request object (as ORDER_HANDLER does). Note that this usage of execution variables ensures your routines can successfully cope with simultaneous requests. If you encounter a problem generating the content, then add an error to req.error_handler.

As well as the request object, we provide the results of content negotiation, so you can generate the entity in the agreed format. If you only support one format (i.e. all of mime_types_supported, charsets_supported, encodings_supported and languages_supported are one-element lists), then you are guaranteed that this is what you are being asked for, and so you can ignore them.

### content

When not streaming, this routine provides the entity to the framework (for GET or DELETE). Normally you would just access the execution variable that you set in ensure_content_available. Again, the results of content negotiation are made available, but you probably don't need them at this stage. If you only stream responses (for GET), and if you don't support DELETE, then you don't need to do anything here.

### generate_next_chunk

When streaming the response, this routine is called to enable you to generate chunks beyond the first, so that you can incrementally generate the response entity. If you generated the entire response entity in 
ensure_content_available, then you do nothing here. Otherwise, you will generate the next chunk, and save it in the same execution variable that you use in ensure_content_available (or add an error to req.error_handler). If you don't support streaming, then you don't need to do anything here.

### next_chunk

When streaming the response, the framework calls this routine to provides the contents of each generated chunk. If you generated the entire response entity in ensure_content_available, then you need to slice it in this routine (you will have to keep track of where you are with execution variables). If instead you generate the response incrementally, then your task is much easier - you just access the execution variable saved in ensure_content_available/generate_next_chunk.
As in all these content-serving routines, we provide the results of content negotiation. This might be necessary, for instance, if you were compressing an incrementally generated response (it might be more convenient to do the compression here rather than in both ensure_content_available and generate_next_chunk).
 
### read_entity

This is called for PUT and POST processing, to read the entity provided in the request. A default implementation is provided. This assumes that no decoding (e.g. decompression or character set conversion) is necessary. And it saves it in the execution variable REQUEST_ENTITY.

Currently the framework provides very little support for PUT and POST requests (so you may well need to redefine this routine). There are several reasons for this:

1. I personally don't have much experience with PUT and POST.
1. It has taken a long time to develop this framework, and to some extent I was working in the dark (I couldn't check what I was doing until the entire framework was written - it wouldn't even compile before then).
1. The idea for the framework came from a code review process on servers I had written for the company that I work for. I had acquired a lot of knowledge of the HTTP protocol in the process, and some of it showed in the code that I had written. It was thought that it would be a good idea if this knowledge were encapsulated in Eiffel, so other developers would be able to write servers without such knowledge. So this framework has been developed in company time. However, at present, we are only using GET requests.

Experience with converting the restbucksCRUD example to use the framework, shows that it is certainly possible to do POST and PUT processing with it. But enhancements are needed, especially in the area of decoding the request entity.

## Implementing the policies

* [WSF_OPTIONS_POLICY](./WSF_OPTIONS_POLICY)
* [WSF_PREVIOUS_POLICY](./WSF_PREVIOUS_POLICY)
* [WSF_CACHING_POLICY](./WSF_CACHING_POLICY)