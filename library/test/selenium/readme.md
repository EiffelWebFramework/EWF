Eiffel Selenium binding
=================================================

##  Overview

This client is a binding for the REST API interface defined in the WebDriver protocol http://code.google.com/p/selenium/wiki/JsonWireProtocol.

WARNING this API is still under development, and maybe it will change

##  Requirements

*  Get the server selenium-server-standalone-#.jar file provided here:  http://code.google.com/p/selenium/downloads/list

*   Download and run that file, replacing # with the current server version.

        java -jar selenium-server-standalone-#.jar
		(it only has a Firefox WebDriver by default)
		
		But you can add other drivers doing something like that (change PATH_TO to the corresponding value in your environment)
		java -jar selenium-server-standalone-2.32.0.jar  
		-Dwebdriver.chrome.driver=%PATH_TO%\chromedriver.exe  -Dwebdriver.ie.driver=%PATH_TO%\IEDriverServer.exe 
		
##  Getting Started 

TODO


