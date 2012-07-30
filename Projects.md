This page lists potential projects on EWF, this is open for contribution.
If you are a student, don't hesitate to pick one, or even suggest a new project, or a project being a merge of several, in any case, you will get close support from EWF's team. 

----
# Studies/Analysis/Documentation

## Evaluate EWF according to the following constraints ... 
* _Suggested by **Javier**_
* See http://www.amundsen.com/blog/archives/1130
* Other option is take the following REST implementation toolkit as a guide to evaluate EWF http://code.google.com/p/implementing-rest/wiki/RESTImplementationToolkit.

## Road to Hypermedia API 
* _Suggested by **Javier**_
* describe differents types of Web API, and how you can build them using EWF. 
* Describing Pros and Cons.
* based on http://martinfowler.com/articles/richardsonMaturityModel.html


## Build a video to demonstrate how an Hypermedia API works, and how to build it using EWF 
* _Suggested by **Javier**_
* (maybe based on our graphviz example) or and extension to RestBucksCRUD

----
# Works related to EWF / framework / tools

## Improve EWF
* _Suggested by **Jocelyn**_
* Improve encoding support 
∗ Better MIME handler
* Support for configuration
* Ready to use logging facilities
* Smart handler for HEAD or similar
* Adding component to ease the caching functionalities
* Adding Session support
* URL rewriting ?
* Mass testing
* ...

## Eiffel Web Nino
* _Suggested by **Javier & Jocelyn**_
* Implement persistent connection
* Complete implementation of Eiffel Web Nino using pool of threads
* Complete migration of Eiffel Web Nino to SCOOP
* Improve Nino to become a real solution to host any web services/sites
* ...

## New EWF connectors 
* _Suggested by **Jocelyn & Javier**_
* LightHTTP connector for EWF
* nginx connector for EWF
* ...

## Concurrenty and EWF
* _Suggested by **Jocelyn**_
* Make sure EWF is compliant with concurrency, provide example

## Design and build something like Ruby on Rails or Grails 
* _Suggested by **Javier**_
* i.e a conventional MVC to create Web Sites
* Could be useful even if this is not the taste of everyone


## Provide a Websocket implementation
* _Suggested by **Jocelyn**_
* See http://en.wikipedia.org/wiki/Websocket

----
# Usage of EWF

## HAL browser 
* _Suggested by **Javier**_
* written in Eiffel inspired by http://haltalk.herokuapp.com/explorer/hal_browser.html#/
* see http://stateless.co/hal_specification.html

## Collection-JSON browser
* _Suggested by **Javier**_
* similar to HAL browser but focused on Collection JSON
* see http://www.amundsen.com/media-types/collection/

## Build a simple CMS with EWF
* _Suggested by **Jocelyn**_
* Build a simple CMS website with EWF
* features:
   - user management  (register, login, lost password -> send email)
   - page editing
   - blog
   - template / theme
   - persistency / storage / ...
   - extension at compilation time
* The result should be used by any user to build his own CMS, and extend it easily.

## Build P2P connector
* _Suggested by **Jocelyn**_
* Imagine you want to publish a website running on your machine (behing firewall). One would need to initiate the connection via a public website, this is common for P2P software such as remote assistance (i.e: join.me, teamviewer, showmypc, ...)

----
# Libraries

## Hypermedia API library to work with XHTML 
* _Suggested by **Javier**_
* http://codeartisan.blogspot.com.ar/2012/07/using-html-as-media-type-for-your-api.html

## Add support for Mediatype such as RSS, ATOM, ...
* _Suggested by **Jocelyn**_
* Being able to generate, and also consume RSS, ATOM, ...

## Security: provide popular authentication mecanisms
* _Suggested by **Jocelyn**_
* OAuth: consumer and provider
* OpenID
* Google Connect
* Facebook Connect
* ...

## Design a state machine to serve response
* _Suggested by **Jocelyn**_
* example: multipage web form

## library: Template engine
* _Suggested by **Jocelyn**_
* Get inspired by any existing template engine, and build one for Eiffel
  - http://www.smarty.net/
  - http://mustache.github.com/
  - ...
* This is not specific to EWF, but it will be very useful in website context

## library: Wikitext, markdown parser and renderer
* _Suggested by **Jocelyn**_
* Support reading of wikitext, and markdown, and provide HTML rendering
* extension: render wikitext and markdown into Vision2 widget (not related to EWF, but could be useful to build editor)

## library: Web component to build HTML5 widget
* _Suggested by **Jocelyn**_
* Build set of Eiffel component to ease development of websites
  - table widget (with sorting ...)
  - suggestive typing widget
  - tab ...
  - WYSIWYG textarea widget (could reuse existing JS solution ...)
  - ...

----
# Clients

## Libraries: Reusable Client Design based on J.Moore Presentation 
* _Suggested by **Javier**_
* Generic client that can be customized (see design in slide 12)
* http://s3.amazonaws.com/cimlabs/Oredev-Hypermedia-APIs.pdf
* video http://vimeo.com/20781278

## Create a Client Cache based on Apache commons Client Cache. 
* _Suggested by **Javier**_
* http://hc.apache.org/httpcomponents-client-ga/httpclient-cache/index.html
* http://labs.xfinity.com/benchmarking-the-httpclient-caching-module

## Add SSL support to Eiffel Net
* _Suggested by **Jocelyn**_
* Currently Eiffel Net does not provide any support to SSL (thus no HTTPS). For now Eiffel application often use the Eiffel cURL wrapper, but it would be more convenient to use directly Eiffel Net.

## Build clients to consume popular RESTful APIs 
* _Suggested by **Jocelyn & Javier**_
* **Requirement**: OAuth client eiffel component
* Google Discovery APIs
* Twitter
* Facebook
* Github
* Flickr
* ... etc
* This should reuse and improve the "http_client" provided by EWF. Eventually also write the EiffelNet implementation to be independant from cURL

----
# Feel free to add new idea below this line
----