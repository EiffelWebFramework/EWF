note
	description: "Summary description for {EXAMPLE_SEARCH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_SEARCH

feature -- Example
	search
		local
			web_driver : WEB_DRIVER
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
		     	print ("Page title is:" + l_title)
		     end

			-- close the window
			web_driver.window_close


		end
end
