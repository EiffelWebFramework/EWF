---
layout: default
title: Connectors
base_url: ../../
---
The main goal of the connectors is to let you choose a target at compile time.
This allows you to concentrate on your business during development time and then decide which target you choose at deployment time.
The current connectors are:
* Nino
* FastCGI
* CGI
* OpenShift

The most widely used workflow is to use Nino on your development machine and FastCGI on your production server.
Nino being a web server written entirely in Eiffel, you can inspect your HTTP requests and respones in EiffelStudio which is great during development.
On the other hand, FastCGI is great at handling concurrent requests and coupled with Apache (or another web production server), you don't even need to worry about the lifecyle of your application (creation and destruction) as Apache will do it for you!

Let's now dig into each of the connecters.

# Nino

Nino is a web server entirely written in Eiffel.
The goal of Nino is to provide a simple web server for development (like Java, Python and Ruby provide).
Nino is currently maintained by Javier Velilla and the repository can be found here: https://github.com/jvelilla/EiffelWebNino

# FastCGI

FastCGI is a protocol for interfacing an application server with a web server.
It is an improvement over CGI as FastCGI supports long running processes, i.e. processes than can handle multipe requests during their lifecyle. CGI, on the other hand, launches a new process for every new request which is quite time consuming.
FastCGI is implemented by every major web servers: Apache, IIS, Nginx, ...
We recommend to use FastCGI instead of CGI as it is way more faster.
You can read more about FastCGI here: http://www.fastcgi.com/

# CGI

CGI predates FastCGI and is also a protocol for interfacing an application server with a web server.
His main drawback (and the reason why FastCGI was created) is that it launches a new process for every new request, which is quite time consuming.
We recommend to use FastCGI instead of CGI as it is way more faster.

# OpenShift

OpenShift is a cloud computing platform as a service product from Red Hat.
It basically let's you run your application in the cloud.
More informations are available here: https://www.openshift.com 

# Writing your own

It's fairly easy to write your own connector. Just inherit from these classes:
* WGI_CONNECTOR
* WGI_ERROR_STREAM
* WGI_INPUT_STREAM
* WGI_OUTPUT_STREAM
* WSF_SERVICE_LAUNCHER


See WSF_CONNECTOR
