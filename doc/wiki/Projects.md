This page lists potential projects on EWF, this is open for contribution.
If you are a student, don't hesitate to pick one, or even suggest a new project, or a project being a merge of several, in any case, you will get close support from EWF's team. 

----
# Study/Analysis/Documentation

## Evaluate EWF according to the following constraints ... 
* _Suggested by **Javier**_
* _Description_: According to [http://www.amundsen.com/blog/archives/1130](http://www.amundsen.com/blog/archives/1130) , evaluate the current design of EWF to see if this match the different points. An other option would be to take the following REST implementation toolkit as a guide to evaluate EWF [http://code.google.com/p/implementing-rest/wiki/RESTImplementationToolkit](http://code.google.com/p/implementing-rest/wiki/RESTImplementationToolkit).

## Road to Hypermedia API 
* _Suggested by **Javier**_
* _Supervisor_:
* _Suitability_: 
* _Description_:  describe differents types of Web API, and how you can build them using EWF. Describing Pros and Cons. This should be on [http://martinfowler.com/articles/richardsonMaturityModel.html](http://martinfowler.com/articles/richardsonMaturityModel.html)

## Build a video to demonstrate how an Hypermedia API works, and how to build it using EWF 
* _Suggested by **Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: produce a audio+video+slide that demonstrates how to build an hypermedia API using EWF. This could be based on upcoming "graphviz server" example, or an extension of existing RestBucksCRUD example, or any new example.

----
# Works related to EWF / framework / tools

## Improve EWF
* _Suggested by **Jocelyn**_
* _Supervisor_: 
* _Suitability_: TODO 
* _Description_: Improve existing EWF source, this is a permanent task for EWF, and this can be code, documentation, tests, ... Among others , here is a list of needed effort:
** Improve encoding support 
*∗ Better MIME handler
** _Support for configuration _
** Ready to use logging facilities
** Smart handler for HEAD or similar
** Adding component to ease the caching functionalities
** Adding Session support
** URL rewriting ?
** Mass testing
** ...

## Eiffel Web Nino
* _Suggested by **Javier & Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_:  Currently Eiffel Web Nino, is a standalone httpd server written in Eiffel. It is great for development, or embedding httpd component in application. However there are room for improvement so that one can also use it as replacement for apache, iis, ... To reach this state, here are a list of task that should be achieved:
** Implement persistent connection
** Complete implementation of Eiffel Web Nino using pool of threads
** Complete migration of Eiffel Web Nino to SCOOP
** Improve Nino to become a real solution to host any web services/sites
** ...

## New EWF connectors 
* _Suggested by **Jocelyn & Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: EWF is relying on the notion of "connector" to achieve portability on various platform and underlying httpd server, currently EWF support any CGI or libFCGI system (i.e apache, IIS, ...), and provide a standalone version thanks to Eiffel Web Nino. The goal now, would be to support specific connector for:
** LightHTTP ([http://www.lighttpd.net/](http://www.lighttpd.net/))
** nginx ([http://nginx.org/en/](http://nginx.org/en/))

## Concurrenty and EWF
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Check that EWF is compliant with concurrency (Eiffel Thread, and SCOOP), and provide an example using concurrency.

## Design and build something like Ruby on Rails or Grails 
* _Suggested by **Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_:  Using EWF, design and build the set of tools to provide a conventional MVC to create Web sites. This could be useful even if this is not the taste of everyone.

## Provide a Websocket implementation
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Provide an implementation of websocket with EWF and eventually Eiffel Web Nino, then demonstrate it on a simple example. WebSocket is a web technology providing for bi-directional, full-duplex communications channels over a single TCP connection.
* See [http://en.wikipedia.org/wiki/Websocket](http://en.wikipedia.org/wiki/Websocket)

----
# Usage of EWF

## HAL browser 
* _Suggested by **Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Build a HAL browser to discover an API using HAL mediatype. The browser will be able to follow the links, and display the transmitted data. This could be a vision2 application inspired by [http://haltalk.herokuapp.com/explorer/hal_browser.html#/](http://haltalk.herokuapp.com/explorer/hal_browser.html#/). HAL stands for Hypertext Application Language see [http://stateless.co/hal_specification.html](http://stateless.co/hal_specification.html).

## Collection-JSON browser
* _Suggested by **Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Build a Collection/JSON browser to discover an API using Collection/JSON mediatype. The browser will be able to follow the links, and display the transmitted data. This could be a vision2 application inspired by [http://haltalk.herokuapp.com/explorer/hal_browser.html#/](http://haltalk.herokuapp.com/explorer/hal_browser.html#/). Collection+JSON is a JSON-based read/write hypermedia-type, see [http://www.amundsen.com/media-types/collection/](http://www.amundsen.com/media-types/collection/)

## Build a simple CMS with EWF
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Status_: started, and open for contribution, collaboration, please contact Jocelyn.
* _Description_: Using EWF, Build a simple CMS (Content Management System) framework and then an example. It should provide common features such as:
   - user management  (register, login, lost password -> send email)
   - page editing
   - blog
   - template / theme
   - persistency / storage / ...
   - extension at compilation time
* The result should be usable by any user to build his own CMS website, and extend it easily.

## Build P2P connector
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Imagine you want to publish a website (or web service, API) running on your machine (behind firewall). One would need to initiate the connection via a public website, this is common for P2P software such as remote assistance (i.e: join.me, teamviewer, showmypc, ...)

----
# Libraries

## Hypermedia API library to work with XHTML 
* _Suggested by **Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Use XHTML as a media type to for hypermedia API. See [http://codeartisan.blogspot.com.ar/2012/07/using-html-as-media-type-for-your-api.html](http://codeartisan.blogspot.com.ar/2012/07/using-html-as-media-type-for-your-api.html)

## Add support for Mediatype such as RSS, ATOM, ...
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: In addition to JSON, HAL, Collection+JSON, XHTML, application might want to support (read and write) standard media type such as RSS, ATOM, ...

## Security: provide popular authentication mechanisms
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Any web service, web site, API need a reliable authentication mechanism, the could be on the server side or the client side to build mashup service (integrate with other web API such as google, flicker, ...). So far, EWF provides only basic HTTP Authorization, and application would need more solutions such as :
   - OAuth: consumer and provider
   - OpenID
   - Google Connect
   - Facebook Connect
* The goal is to provide component to consume other popular API/service, but also component for your own service so that other can consume it.

## Security: provide popular authentication mechanisms
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Any web service, web site, API need a reliable authentication mechanism, the could be on the server side or the client side to build mashup service (integrate with other web API such as google, flicker, ...). So far, EWF provides only basic HTTP Authorization, and application would need more solutions such as :
   - OAuth: consumer and provider
   - OpenID
   - Google Connect
   - Facebook Connect
* The goal is to provide component to consume other popular API/service, but also component for your own service so that other can consume it.

## Provide a SSO (Single Sign On) implementation (server, and clients)
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Design and build a Single Sign On implementation for Eiffel. That should include the authentication server, and at least one Eiffel client component (it would be convenient to also provide php, js, ...). In the same spirit, having Eiffel client for popular SSO server would be appreciated as well.
* _Reference_: 
    - [http://en.wikipedia.org/wiki/Single_sign-on](http://en.wikipedia.org/wiki/Single_sign-on)
    - [http://en.wikipedia.org/wiki/List_of_single_sign-on_implementations](http://en.wikipedia.org/wiki/List_of_single_sign-on_implementations)

## library: Template engine
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Get inspired by any existing template engine, and build one for Eiffel, this should be easily usable within a web application. This could be inspired, or implementation of standard template engine, this way people can reuse existing content, or migrate easily their application to EWF. For inspiration, one can look at:
  - [http://www.smarty.net/](http://www.smarty.net/)
  - [http://mustache.github.com/](http://mustache.github.com/)
  - [http://en.wikipedia.org/wiki/Web_template_system](http://en.wikipedia.org/wiki/Web_template_system) ... they are plenty of them, a comparison of the different engine would help.
* This is not specific to EWF, but it will be very useful in website context.

## library: Wikitext, markdown parser and render engine
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Build component to support (read and write, and why not convert), lightweight markup language (see [http://en.wikipedia.org/wiki/Lightweight_markup_language](http://en.wikipedia.org/wiki/Lightweight_markup_language)) such as wikitext, markdown, and other. The component should be able to read/scan, but also produce an HTML output. Focus first on wikitext, and markdown since they seems to be the most popular.
* Then , a nice addition would be to render those lightweight markup lang into Vision2 widget (not related to EWF, but could be useful to build (editor) desktop application)

## library: Web component to build HTML5 widget
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Build set of Eiffel components to ease development of websites. First this should be based on HTML5. Idea for components:
  - table widget (with sorting ...)
  - suggestive typing widget
  - tab ...
  - WYSIWYG textarea widget (could reuse existing Javascript solution TinyMCE, CKEditor, OpenWysiwyg,﻿ ...)
  - ...

----
# Clients

## Libraries: Reusable Client Design based on J.Moore Presentation 
* _Suggested by **Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: TODO 
* Generic client that can be customized (see design in slide 12)
* [http://s3.amazonaws.com/cimlabs/Oredev-Hypermedia-APIs.pdf](http://s3.amazonaws.com/cimlabs/Oredev-Hypermedia-APIs.pdf)
* video [http://vimeo.com/20781278](http://vimeo.com/20781278)

## Create a Client Cache based on Apache commons Client Cache. 
* _Suggested by **Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: TODO 
* [http://hc.apache.org/httpcomponents-client-ga/httpclient-cache/index.html](http://hc.apache.org/httpcomponents-client-ga/httpclient-cache/index.html)
* [http://labs.xfinity.com/benchmarking-the-httpclient-caching-module](http://labs.xfinity.com/benchmarking-the-httpclient-caching-module)

## Add SSL support to Eiffel Net
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Currently Eiffel Net does not provide any support to SSL (thus no HTTPS). For now Eiffel application often use the Eiffel cURL wrapper which provide SSL, but it would be more convenient to use directly Eiffel Net. Then find solution to add SSL support to EiffelNet, or to extend EiffelNet with an EiffelNet+OpenSSL solution, or other.

## Build clients to consume popular RESTful APIs 
* _Suggested by **Jocelyn & Javier**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: Build Eiffel libraries to consume popular web APIs, such as:
   - Google Discovery APIs
   - Twitter
   - Facebook
   - Github
   - Flickr
   - ... etc
* This should reuse and improve the "http_client" provided by EWF. Eventually also write the EiffelNet implementation to be independant from cURL
* **Requirement**: OAuth client eiffel component

## Build a ESI preprocessor, or proxy
* _Suggested by **Jocelyn**_
* _Supervisor_:  
* _Suitability_: TODO 
* _Description_: TODO 
* See: [http://en.wikipedia.org/wiki/Edge_Side_Includes](http://en.wikipedia.org/wiki/Edge_Side_Includes)

----
# Feel free to add new idea below this line
----
Use the following page [Projects new suggestions](Projects-new-suggestions.md) to suggest new project, or request a feature.
