---
layout: default
title: Wsf previous policy
base_url: ../../../
---
# WSF_PREVIOUS_POLICY

This class deals with resources that have moved or gone. The default assumes no such resources. It exists as a separate class, rather than have the routines directly in WSF_SKELETON_HANDLER, as sub-classing it may be convenient for an organisation.

## resource_previously_existed

Redefining this routine is always necessary if you want to deal with any previous resources.

## resource_moved_permanently

Redefine this routine for any resources that have permanently changed location. The framework will generate a 301 Moved Permanently response, and the user agent will automatically redirect the request to (one of) the new location(s) you provide. The user agent will use the new URI for future requests.

## resource_moved_temporarily

This is for resource that have only been moved for a short period. The framework will generate a 302 Found response. The only substantial difference between this and resource_moved_permanently, is that the agent will use the old URI for future requests.

## previous_location

When you redefine resource_moved_permanently or resource_moved_temporarily, the framework will generate a Location header for the new URI, and a hypertext document to the new URI(s). You **must** redefine this routine to provide those locations (the first one you provide will be in the location header).