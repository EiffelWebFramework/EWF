# Using the policy driven framework

## Introduction

The aim of the policy-driven framework is to allow authors of web-servers to concentrate on the business logic (e.g., in the case of a GET request, generating the content), without having to worry about the details of the HTTP protocol (such as headers and response codes). However, there are so many possibilities in the HTTP protocol, that it is impossible to correctly guess what to do in all cases. Therefore the author has to supply policy decisions to the framework, in areas such as caching decisions. These are implemented as a set of deferred classes for which the author needs to provide effective implementations.

## Mapping the URI space

The authors first task is to decide which URIs the server will respond to (we do this using [URI templates](http://tools.ietf.org/html/rfc6570) ) and which methods are supported for each template.This is done in the class that that defines the service (which is often the root class for the application). This class must be a descendant of WSF_ROUTED_SKELETON_SERVICE.