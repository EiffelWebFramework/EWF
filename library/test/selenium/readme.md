Eiffel Selenium binding
=================================================

##  Overview
Selenium will help you test your web applications effectively and efficiently against a vast number of browsers and platforms.
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
		
##  Getting Started Selenium-WebDriver API 
(Eiffel binding only support (for now) RemoteWebDriver) 
The examples and guide are based on http://docs.seleniumhq.org/docs/03_webdriver.jsp#introducing-the-selenium-webdriver-api-by-example

WebDriver is a tool for automating web application testing, and in particular to verify that they work as expected. 

   class
	EXAMPLE_SEARCH
	inherit
		ANY
		redefine
			default_create
		end
	feature
		default_create
		do
			search
		end
	feature -- Example
		search
			local
				web_driver : WEB_DRIVER
				wait : WEB_DRIVER_WAIT
			do
				--Create a new instance of a Web driver
       				create web_driver.make

 	      			-- Start session with chrome
       				web_driver.start_session_chrome

       				-- Go to Google
       				web_driver.to_url ("http://www.google.com/")

		       		-- Find the text input element by its name
    	     			if attached web_driver.find_element ((create{SE_BY}).name ("q")) as l_element then

  					-- Enter something to search for
   	    				l_element.send_keys(<<"Eiffel Room">>)

     	  				-- Now submit the form. WebDriver will find the form for us from the element
     					l_element.submit

		     		 end
				 if attached web_driver.get_page_tile as l_title then
		     			print ("%NPage title is:" + l_title)
		     		 end

		    		 -- Google's search is rendered dynamically with JavaScript.
        			-- Wait for the page to load, timeout after 10 seconds
		   	 	create wait.make (web_driver,10)
			 	wait.until_when (agent expected_title (web_driver, "Eiffel Room"))


			  	if attached web_driver.get_page_tile as l_title then
		     			print ("%NPage title is:" + l_title)
		     		end

				-- close the window
				web_driver.window_close
			end

		expected_title (driver : WEB_DRIVER; title : STRING_32) : BOOLEAN
			do
				if attached {STRING_32} driver.get_page_tile as l_title and then l_title.has_substring (title) then
					Result := True
				end
			end

	end

    

	
### Selenium-WebDriver API Commands and Operations
To learn more go to [Selenium documentation] (http://docs.seleniumhq.org/docs/03_webdriver.jsp#introducing-the-selenium-webdriver-api-by-example) 
##### Fetching a Page
	The first thing you are likely to want to do with WebDriver is navigate to a page. 
	
		web_driver.to_url ("http://www.google.com/")

##### Locating UI Elements (WebElements)
###### By ID
Example of how to find an element that looks like this:

    <div id="head">...</div>

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).id ("head"))
    

###### By Name

Example of how to find an element that looks like this:

    <input name="cheese" type="text"/>

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).name ("cheese"))

###### By Class Name

Example of how to find an element that looks like this:

    <div class="cheese"><span>Cheddar</span></div><div class="cheese"><span>Gouda</span></div>

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).class_name ("cheese"))

###### By CSS Selector

Example of how to find an element that looks like this:

    <div id="food"><span class="dairy">milk</span><span class="dairy aged">cheese</span></div>

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).css_selector ("#food span.dairy.aged"))

###### By Link Text

Example of how to find an element that looks like this:

    <a href="http://www.google.com/search?q=EWF">EWF</a>>

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).link_text ("EWF"))


###### By Partial Link Text

Example of how to find an element that looks like this:

    <a href="http://www.google.com/search?q=ewf">search for ewf</a>>

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).partial_link_text ("ewf"))


###### By Tag Name

Example of how to find an element that looks like this:

    <iframe src="..."></iframe>

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).tag_name ("iframe"))


###### By XPath


Example of how to find an element that looks like this:

    <input type="text" name="example" />

Eiffel Code
    
    web_driver.find_element ((create{SE_BY}).xpath ("//input"))


### Locating Elements


