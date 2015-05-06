# Eiffel Web Framework


## Overview

The Eiffel Web Framework (EWF) provides Eiffel users with a layer to build anything on top of the http protocol such as websites, web API/services. 

This layer is multi-platform: it can be set on Windows, Linux operating systems, and in addition it can run on top of any httpd servers such as Apache2, IIS, nginx, lighttpd. EWF includes as well a standalone httpd web server component, written in Eiffel, which enables users to run easily a web server on their machine, or even embed this component in any application written with Eiffel.

Currently EWF offers a collection of Eiffel libraries designed to be integrated with each others, and among other functionalities, it give simple access to the request data, to handle content negotiation, url dispatcher, integrate with openid system, and so on. 

There is a growing ecosystem around EWF, that provides useful components:
* OpenID and OAuth consumer library
* Various hypermedia format such as HAL, Collection+json, …
* Websocket server and client
* Template engine
* API Auto-documentation with swagger
* A simple experimental CMS.
* ...

So if you want to build a website, a web api, RESTful service, …or even if you want to consume other web api, EWF is a solution.

EWF brings with it all the advantages of the Eiffel technology and tools with its powerful features such as Design by Contract, debugging, testing tools which enable to build efficient systems expected to be repeatedly refined, extended, and improved in a predictable and controllable way so as to become with time bugfree systems. Enjoy the full power of debugging your web server application from the IDE.

## Project

Official project site for Eiffel Web Framework:

* http://eiffelwebframework.github.com/EWF/

For more information please have a look at the related wiki:

* https://github.com/EiffelWebFramework/EWF/wiki

For download, check
* https://github.com/EiffelWebFramework/EWF/downloads

Tasks and issues are managed with github issue system
* See https://github.com/EiffelWebFramework/EWF/issues
* And visual dashboard: https://waffle.io/eiffelwebframework/ewf

## Requirements
* Compiling from EiffelStudio 14.05 and more recent version of the compiler.
* Developped using EiffelStudio 15.05 (on Windows, Linux)
* Tested using EiffelStudio 15.05 with "jenkins" CI server (not anymore compatible with 6.8 due to use of `TABLE_ITERABLE')
* The code have to allow __void-safe__ compilation and non void-safe system (see [more about void-safety](http://docs.eiffel.com/book/method/void-safe-programming-eiffel) )

## How to get the source code?

Using git 
* git clone https://github.com/EiffelWebFramework/EWF.git

* And to build the required and related Clibs
  * cd contrib/ise_library/cURL
  * geant compile

## Libraries under 'library'

### server
* __ewsgi__: Eiffel Web Server Gateway Interface [read more](library/server/ewsgi)
  * connectors: various web server connectors for EWSGI
* libfcgi: Wrapper for libfcgi SDK 
* __wsf__: Web Server Framework [read more](library/server/wsf)
  *  __router__: URL dispatching/routing based on uri, uri_template, or custom [read more](library/server/wsf/router)

### protocol
* __http__: HTTP related classes, constants for status code, content types, ... [read more](library/protocol/http)
* __uri_template__: URI Template library (parsing and expander) [read more](library/protocol/uri_template)
* __CONNEG__: Content negotiation library (Content-type Negociation) [read more](library/protocol/content_negotiation)

### client
* __http_client__: simple HTTP client based on cURL [read more](library/client/http_client)

### text
* __encoder__: Various simpler encoders: base64, url-encoder, xml entities, html entities [read more](library/text/encoder)

### Others
* error: very simple/basic library to handle error

## External libraries under 'contrib'
* [Eiffel Web Nino](contrib/library/server/nino)
* ..

## Draft folder = call for contribution ##

## Examples
..

## Contributing to this project

Anyone and everyone is welcome to contribute. Please take a moment to
review the [guidelines for contributing](CONTRIBUTING.md).

* [Bug reports](CONTRIBUTING.md#bugs)
* [Feature requests](CONTRIBUTING.md#features)
* [Pull requests](CONTRIBUTING.md#pull-requests)

## Community

Keep track of development and community news.

* Follow [@EiffelWeb](https://twitter.com/EiffelWeb) on Twitter
* Follow our [page](https://plus.google.com/u/0/110650349519032194479) and [community](https://plus.google.com/communities/110457383244374256721) on Google+
* Have a question that's not a feature request or bug report? [Ask on the mailing list](http://groups.google.com/group/eiffel-web-framework)


For more information please have a look at the related wiki:
* https://github.com/EiffelWebFramework/EWF/wiki
