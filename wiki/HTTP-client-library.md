---
layout: default
title: HTTP client library
base_url: ../../
---
# HTTP Library Features
The following list of features are taken form the book [RESTful Web Services](http://www.amazon.com/Restful-Web-Services-Leonard-Richardson/dp/0596529260/ref=sr_1_1?ie=UTF8&qid=1322155984&sr=8-1)

* **HTTPS**: _It must support HTTPS and SSL certificate validation_

* **HTTP methods**: _It must support at least the five main HTTP methods: GET, HEAD, POST, PUT, and DELETE. Optional methods
                 OPTIONS and TRACE, and WebDAV extensions like MOVE, ._
* **Custom data** : _It must allow the programmer to customize the data sent as the entity-body of a
PUT or POST request._
* **Custom headers**  : _It must allow the programmer to customize a request’s HTTP headers_
* **Response Codes** :  _It must give the programmer access to the response code and headers of an HTTP
response; not just access to the entity-body._
* **Proxies**: _It must be able to communicate through an HTTP proxy_

* **Compression**:_it should automatically request data in compressed form to save
bandwidth, and transparently decompress the data it receives._
* **Caching**:_It should automatically cache the responses to your requests._
* **Auth methods** : _It should transparently support the most common forms of HTTP authentication:
Basic, Digest, and WSSE._
* **Cookies** :_It should be able to parse and create HTTP cookie strings_
* **Redirects**:_It should be able to transparently follow HTTP redirects_