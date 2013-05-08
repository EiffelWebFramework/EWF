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
		
##  Getting Started Selenium-WebDriver API (Eiffel binding only support (for now) RemoteWebDriver) 
The examples and guide are based on http://docs.seleniumhq.org/docs/03_webdriver.jsp#introducing-the-selenium-webdriver-api-by-example

WebDriver is a tool for automating web application testing, and in particular to verify that they work as expected. 

   
    class
    	EXAMPLE_SEARCH
    
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
    			 wait.until_when ("Eiffel Room")
    
    
    			  if attached web_driver.get_page_tile as l_title then
    		     	print ("%NPage title is:" + l_title)
    		     end
    
    			-- close the window
    			web_driver.window_close
    		end
    end

	
### Selenium-WebDriver API Commands and Operations
	Fetching a Page
	The first thing you’re likely to want to do with WebDriver is navigate to a page. 
	
		web_driver.to_url ("http://www.google.com/")
	
	
### Locating Elements


