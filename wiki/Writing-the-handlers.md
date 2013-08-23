---
layout: default
title: Writing the handlers
base_url: ../../
---
# Writing the handlers

Now you have to implement each handler. You need to inherit from WSF_SKELETON_HANDLER (as ORDER_HANDLER does). This involves implementing a lot of deferred routines. There are other routines for which default implementations are provided, which you might want to override. This applies to both routines defined in this class, and those declared in the three policy classes from which it inherits.

## Communicating between routines

Depending upon the connector (Nino, CGI, FastCGI etc.) that you are using, your handler may be invoked concurrently for multiple requests. Therefore it is unsafe to save state in normal attributes. WSF_REQUEST has a pair of getter/setter routines, execution_variable/set_execution_variable, which you can use for this purpose.
Internally, the framework uses the following execution variable names, so you must avoid them:

1. REQUEST_ENTITY
1. NEGOTIATED_LANGUAGE
1. NEGOTIATED_CHARSET
1. NEGOTIATED_MEDIA_TYPE
1. NEGOTIATED_ENCODING
1. NEGOTIATED_HTTP_HEADER
1. CONFLICT_CHECK_CODE
1. CONTENT_CHECK_CODE
1. REQUEST_CHECK_CODE

The first one makes the request entity from a PULL or POST request available to your routines. 

The next four make the results of content negotiation available to your routines. The sixth one makes an HTTP_HEADER available to your routines. You should use this rather than create your own, as it may contain a **Vary** header as a by-product of content negotiation.
The last three are for reporting the result from check_conflict, check_content and check_request.

All names are defined as constants in WSF_SKELETON_HANDLER, to make it easier for you to refer to them.

## Implementing the routines declared directly in WSF_SKELETON_HANDLER

### check_resource_exists

Here you check for the existence of the resource named by the request URI. If it does, then you need to call set_resource_exists on the helper argument.
Note that if you support multiple representations through content negotiation, then etags are dependent upon
the selected variant. If you support etags, then you will need to make the response entity available at this point, rather than in ensure_content_available.

### is_chunking

HTTP/1.1 supports streaming responses (and providing you have configured your server to use a proxy server in WSF_PROXY_USE_POLICY, this framework guarantees you have an HTTP/1.1 client to deal with). It is up to you whether or not you choose to make use of it. If so, then you have to serve the response one chunk at a time (but you could generate it all at once, and slice it up as you go). In this routine you just say whether or not you will be doing this. So the framework n=knows which other routines to call.
Currently we only support chunking for GET or HEAD routines. This might change in the future, so if you intend to return True, you should call req.is_get_head_request_method.
Note that currently this framework does not support writing a trailer. 

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
Note that if you support multiple representations through content negotiation, then etags are dependent upon
the selected variant. Therefore you will need to have the response entity available for this routine. This can be done in check_resource_exists.

### etag

You are strongly encouraged to return non-Void for this routine. See [Validation Model](http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.3) for more details.
Note that if you support multiple representations through content negotiation, then etags are dependent upon
the selected variant. Therefore you will need to have the response entity available for this routine. This can be done in check_resource_exists.

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

Note that if you support multiple representations through content negotiation, then etags are dependent upon
the selected variant. Therefore you will need to have the response entity available for this routine. In such cases, this will have to be done in check_resource_exists, rather than here, as this routine is called later on.

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

### is_entity_too_large

If your application has limits on the size of entities that it can store, then you implement them here.

### check_content_headers

This is called after is_entity_too_large returns False. You are supposed to check the following request headers, and take any appropriate actions (such as setting an error, decompression the entity, or converting it to a different character set):

* Content-Encoding
* Content-Language
* Content-MD5
* Content-Range
* Content-Type

At the moment, your duty is to set the execution variable CONTENT_CHECK_CODE to zero, or an HTTP error status code. A future enhancement of the framework might be to provide more support for this.

### content_check_code

This simply accesses the execution variable CONTENT_CHECK_CODE set in check_content_headers. if you want to use some other mechanism, then you can redefine this routine.

### create_resource

This routine is called when a PUT request is made with a URI that refers to a resource that does not exist (PUT is normally used for updating an existing resource), and you have already decided to allow this.
In this routine you have the responsibilities of:

1. Creating the resource using the entity in REQUEST_ENTITY (or some decoded version that you have stored elsewhere).
1. Writing the entire response yourself (as I said before, support for PUT and POST processing is poor at present), including setting the status code of 201 Created or 303 See Other or 500 Internal server error).

### append_resource

This routine is called for POST requests on an existing resource (normal usage).

In this routine you have the responsibilities of:

1. Storing the entity from REQUEST_ENTITY (or some decoded version that you have stored elsewhere), or whatever other action is appropriate for the semantics of POST requests to this URI.
1. Writing the entire response yourself (as I said before, support for PUT and POST processing is poor at present), including setting the status code of 200 OK, 204 No Content, 303 See Other or 500 Internal server error).

### check_conflict

This is called for a normal (updating) PUT request. You have to check to see if the current state of the resource makes updating impossible. If so, then you need to write the entire response with a status code of 409 Conflict, and set the execution variable CONFLICT_CHECK_CODE to 409.
Otherwise you just set the execution variable CONFLICT_CHECK_CODE to 0.

See [the HTTP/1.1 specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4.10) for when you are allowed to use the 409 response, and what to write in the response entity. If this is not appropriate then a 500 Internal server error would be more appropriate (and set CONFLICT_CHECK_CODE to 500 - the framework only tests for non-zero).

### conflict_check_code

This is implemented to check CONFLICT_CHECK_CODE from the previous routine. If you choose to use a different mechanism, then you need to redefine this.

### check_request

This is called for PUT and POST requests. You need to check that the request entity (available in the execution variable REQUEST_ENTITY) is valid for the semantics of the request URI. You should set the execution variable REQUEST_CHECK_CODE to 0 if it is OK. If not, set it to 400 and write the full response, including a status code of 400 Bad Request.

### request_check_code

This routine just checks REQUEST_CHECK_CODE. if you choose to use a different mechanism, then redefine it.

### update_resource

This routine is called for a normal (updating) PUT request. You have to update the state of the resource using the entity saved in the execution environment variable REQUEST_ENTITY (or more likely elsewhere - see what ORDER_HANDLER does). Then write the entire response including a status code of 204 No Content or 500 Internal server error.

## Implementing the policies

* [WSF_OPTIONS_POLICY](../WSF_OPTIONS_POLICY)
* [WSF_PREVIOUS_POLICY](../Wsf-previous-policy)
* [WSF_CACHING_POLICY](../Wsf-caching-policy)