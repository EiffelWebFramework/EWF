note
	description: "Summary description for {EXAMPLE_1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_1

feature -- Access
	test
		local
			web_driver: SE_JSON_WIRE_PROTOCOL
			capabilities: SE_CAPABILITIES
			l_session : SE_SESSION
		do
			create web_driver.make
			if attached web_driver.status as l_status then
				create capabilities.make
				capabilities.set_browser_name ("chrome")
				l_session:= web_driver.create_session_with_desired_capabilities (capabilities)
				if attached l_session as l_s then

					-- navigate to www.google.com
					web_driver.navigate_to_url (l_s.session_id, "http://www.google.com/")

					-- Find the text input element by its name
					if attached {WEB_ELEMENT} web_driver.search_element (l_s.session_id, (create {SE_BY}).name ("q")) as l_element then
						-- search something
						web_driver.send_event(l_s.session_id, l_element.element,<<"Eiffel Room">>)

						-- Submit Form
						web_driver.element_submit (l_s.session_id, l_element.element)

						if attached web_driver.page_title (l_s.session_id) as l_page then
							print ("Page Name" + l_page)
						end
					end
				end

			end
		end

--		// And now use this to visit Google
--        driver.get("http://www.google.com");

--        // Find the text input element by its name
--        WebElement element = driver.findElement(By.name("q"));

--        // Enter something to search for
--        element.sendKeys("Cheese!");

--        // Now submit the form. WebDriver will find the form for us from the element
--        element.submit();

--        // Check the title of the page
--        System.out.println("Page title is: " + driver.getTitle());
end
