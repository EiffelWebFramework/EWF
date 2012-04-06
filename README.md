# Eiffel Web Framework


## Overview

Official project site for Eiffel Web Framework:

* http://eiffelwebframework.github.com/EWF/

For more information please have a look at the related wiki:

* https://github.com/EiffelWebFramework/EWF/wiki

## Requirements

* Developped using EiffelStudio 7.0 (on Windows, Linux)
* Tested using EiffelStudio 7.0 with "jenkins" CI server (and v6.8 for time to time)
* The code have to allow __void-safe__ compilation and non void-safe system (see [more about void-safety](http://docs.eiffel.com/book/method/void-safe-programming-eiffel) )

## How to get the source code?

Using git version >= 1.6.5
* git clone --recursive https://github.com/EiffelWebFramework/EWF.git

Otherwise, try
* git clone https://github.com/EiffelWebFramework/EWF.git
* cd Eiffel-Web-Framework
* git submodule update --init
* git submodule foreach --recursive git checkout master

An alternative to the last 2 instructions is to use the script from tools folder:
* cd tools
* update_git_working_copy

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
* __CONNEG__: CONNEG library (Content-type Negociation) [read more](library/protocol/CONNEG)

### client
* __http_client__: simple HTTP client based on cURL [read more](library/client/http_client)

### text
* __encoder__: Various simpler encoders: base64, url-encoder, xml entities, html entities [read more](library/text/encoder)

### crypto
* eel
* eapml

### Others
* error: very simple/basic library to handle error

## External libraries under 'contrib'
* [Eiffel Web Nino](contrib/library/server/nino)
* ..

## Draft folder = call for contribution ##
### library/server/request ###
* request
  *  rest: (experimental) "a" RESTful library to help building RESTful services

## Examples
..


For more information please have a look at the related wiki:
* https://github.com/EiffelWebFramework/EWF/wiki
