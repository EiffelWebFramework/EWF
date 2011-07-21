Official project site for Eiffel Web Framework:
* https://github.com/Eiffel-World/Eiffel-Web-Framework

For more information please have a look at the related wiki:
* https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki

How to get the source code?
---------------------------

   git clone https://github.com/Eiffel-World/Eiffel-Web-Framework.git
   cd Eiffel-Web-Framework
   git submodule update --init
   git submodule foreach git pull origin master
   git submodule foreach git checkout master

Overview
--------

* library/server/ewsgi: Eiffel Web Server Gateway Interface
* library/server/ewsgi/connectors: various web server connectors for EWSGI
* library/server/libfcgi: Wrapper for libfcgi SDK

* library/protocol/http: HTTP related classes, constants for status code, content types, ...
* library/protocol/uri_template: URI Template library (parsing and expander)

* library/error: very simple/basic library to handle error
* library/text/encoder: Various simpler encoder: base64, url-encoder, xml entities, html entities

For more information please have a look at the related wiki:
* https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki
