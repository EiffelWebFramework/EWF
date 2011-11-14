# Eiffel Web Framework


## Overview

Official project site for Eiffel Web Framework:
* http://eiffel-world.github.com/Eiffel-Web-Framework/

For more information please have a look at the related wiki:
* https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki

## How to get the source code?

* git clone https://github.com/Eiffel-World/Eiffel-Web-Framework.git
* cd Eiffel-Web-Framework
* git submodule update --init
* git submodule foreach --recursive git checkout master

Or using git version >= 1.6.5
* git clone --recursive https://github.com/Eiffel-World/Eiffel-Web-Framework.git

* And to build the required and related Clibs
** cd ext/ise_library/curl
** geant compile

## Libraries under 'library'

* server
  * __ewsgi__: Eiffel Web Server Gateway Interface [read more](library/server/ewsgi/README.md)
    * connectors: various web server connectors for EWSGI
  * libfcgi: Wrapper for libfcgi SDK 
  * __wsf__: Web Server Framework [read more](library/server/wsf/README.md)
  * request
    * __router__: URL dispatching/routing based on uri, uri_template, or custom [read more](library/server/request/router/README.md)
    * rest: experimental: RESTful library to help building RESTful services
* protocol
  * __http__: HTTP related classes, constants for status code, content types, ... [read more](library/protocol/http/README.md)
  * __uri_template__: URI Template library (parsing and expander) [read more](library/protocol/uri_template/README.md)
* client
  * __http_client__: simple HTTP client based on cURL [read more](library/client/http_client/README.md)
* crypto
  * eel
  * eapml
* text
  * __encoder__: Various simpler encoders: base64, url-encoder, xml entities, html entities [read more](library/text/encoder/README.md)
* error: very simple/basic library to handle error

## Examples
..


For more information please have a look at the related wiki:
* https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki
