---
layout: default
title: specification difference in main proposals
base_url: ../../../
---
Currently the **design of the EWSGI** is not going very fast, mainly due to conflicts for the core design.

Let's try to summary today's **points of conflict** between Paul's proposal, and Jocelyn's proposal.
Since Paul put the specification on the wiki from Seibo Solution Studio,
and Jocelyn is implementing the proposal withing the current Eiffel Web Framework.
(If other proposals are provided, we'll compare them to those 2 existing proposals.)

Let's name the **Seibo-EWSGI** proposal and the **EWF-EWSGI** proposal.

Of course, **the goal is to have only one specification**, but it is good to have more than one proposal. So that we really try to specify the best EWSGI as possible.

Let's remind that EWSGI is meant to be a specification, and we are looking at **Specification-Compliance** for the future implementation (so this is mainly about class names, and feature signatures. I.e the Eiffel system interface).

_Note_: to make the code shorter, we will not always include the prefix EWSGI_ to the class name.
_Note2_: we will use the term of "user" for the developer using the EWSGI specification and/or implementation(s)

## General goal ##
At first, the main difference between Seibo-EWSGI and EWF-EWSGI is a tiny nuance on the general goal.
_Seibo-EWSGI_: get web application portability across a variety of web servers.
_EWF-EWSGI_: get web application portability across a variety of web servers including connectors.

Both are following the CGI specification.

To resume, the goal is to get an Eiffel Web ecosystem based on EWSGI specification which allow to write components, libraries, applications based on EWSGI, and which can be compiled and used without changes on the various EWSGI implementations.
EWF-EWSGI is also targetting to make the connector implementations portable on the various EWSGI implementation. However this is not the most critical point, and could be address in later specification version, or maybe a specific EWSGI/Connector specification ...

**Conclusion**: the general goal is (merely) the same for both proposals.
That is a good point, otherwise no need to compare the 2 proposals

## Main entry point for a Web application component ##
This is the first important difference in the class EWSGI_APPLICATION

Seibo-EWSGI:

    response (request: EWSGI_REQUEST): EWSGI_RESPONSE is
            -- The response to the given 'request'.
       deferred
       ensure
           Result.status_is_set
           Result.ready_to_transmit
       end

EWF-EWSGI:

    execute (req: EWSGI_REQUEST; res: EWSGI_RESPONSE_BUFFER)
            -- Execute the request
            -- See `req.input' for input stream
            --     `req.environment' for the Gateway environment    
            -- and `res' for the output buffer
        require
            res_status_unset: not res.status_is_set
        deferred
        ensure
            res_status_set: res.status_is_set
        end

So the main difference is for the user/developer
Seibo-EWSGI: the user has to create the RESPONSE object. 
EWF-EWSGI: the user has the RESPONSE_BUFFER object passed as argument, and it is ready to use.

The consequences are important because

* Seibo-EWSGI: 

   - to make the creation of RESPONSE simple, the decision was to remove any notion of output stream in EWSGI. 
   - Then the RESPONSE has to be built before sending it. But the proposal also provides a way to get the response message by block during the transmission. A kind of delay RESPONSE filling which is for now using a read_block pattern. And this mimics the send immediately the message parts to the client.
   - This design allows the developer to use its own descendant of RESPONSE and then implement the "read_block" pattern when needed.
   - This also allows to control carefully that the status+headers are sent before the body. And if not using the read_block pattern, this allows to set/change the headers even after setting the message body, in fact you really build the Response as an object, and you set the various attributes whenever you want.
   - The read_block pattern is meant to address the case where the message would be too big to stay in memory, and/or to send some part immediately to the client, but for that you must stick to the read_block pattern.
   - Seibo team find the Response-as-Result design more natural, and adopt the Request/Response model of HTTP protocol

* EWF-EWSGI:

   - the RESPONSE_BUFFER is passed by argument to the user, then he does not have to worry about how to create it.
   - it is a buffer and could be implemented in various way by the implementation(s) to access the output stream if any
   - For now, there is no easy way for the user, from the proposed specification, to have a customized RESPONSE_BUFFER
   - It is easy to implement the Seibo-EWSGI design on top of EWF-EWSGI (the code is provided in EWF-ewsgi implementation)
   - the buffer specification allows the user to send the message parts immediately to the client without complicated pattern. As today implementation, the only restriction imposed by the design is to pass the Status code, and the headers before starting sending the message parts; this is checked by the associated assertions. However this part might be thinked again, to be more flexible, and let this to the responsibility of the user, or of other frameworks built on top of EWSGI spec.

## Notion of output stream ##

As you might noticed 
In EWF-EWSGI, the output stream is kind of hidden and replaced by the output buffer, which is in fact quite similar. However the goal is to allow the user to send immediately the message parts to the client as simple as writing in the buffer.
The EWSGI implementation will handle this buffer to integrate nicely with the underlying web server techno. This will be done through the implementation of the various connectors.

In Seibo-EWSGI there is NO notion of output stream, this is to handle the potential case of a HTTP server technologies following CGI specification but without any output stream.
The read_block pattern allows the user to send a big response part by part, and/or also send some message parts immediately to the client during the transmission, this looks like a delayed computation of the messages.

---
So for now, those are the main critical (blocking) differences I (Jocelyn) can see.

## Personal point of views ##

(Feel free to add your own point of view)

### Jocelyn ###

* I prefer the EWF-EWSGI solution (obviously this is my proposal) mainly because with it, you can also implement the Seibo-EWSGI design. And the "more you can do, the less you can also do".
* I find the  read_block pattern really not natural to use in non trivial application (even in trivial application, this might not be that easy to handle, and thus a potential source of bugs)
* I admit the need to send immediately to the client might not be the vast majority of cases. But this is useful for big messages, and for long computing message where the client wants to follow the progression (concrete cases: drupal batch, wordpress online update, ...)
* I would prefer to include the connector part into the EWSGI specification, this way any EWSGI_connector implementation could work with any EWSGI implementation. Otherwise we might end up with many different EWSGI implementations, and according to the underlying connector(s) you want to use, you will need to use different EWSGI implementations.

### Others ... ? ###
Please contribute ... correct also the wiki page if there are mistake or misunderstanding.

