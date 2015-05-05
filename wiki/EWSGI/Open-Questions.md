---
layout: default
title: Open Questions
base_url: ../../
---
## STRING_32, UTF-8, ... ? ##
Berend raised the point that using STRING_32 is consuming 4 times the space used for STRING_8.
And CPU is cheaper than memory, so we should try to use as less memory as possible.
And then for Berend, STRING_32 is not the solution.

Most of the data are just STRING_8 in CGI
so let's list the various request data

- **query_parameter** (from the query string  ?foo=bar&extra=blabla )
   in this case, I think the name can be url-encoded, and obviously the value too
   I guess it makes sense to url-decode them
   but on the other hand, we could just keep them url-encoded (as they are), and it is up to the application to url-decode them if needed.
   Of course, we should provide facilities to url-decode those strings.

- **form_data_parameter** (from the POST method)
   quite often, it is same kind of content that `parameters' 
   but .. here this might depends on the encoding for multi-parts encoding.

- **meta_variable** (from the request itself ... CGI meta variables..)
   I am wondering about unicode domain name ... 

- **input data** ... 
   I think this is up to the application

... to be continued ...
