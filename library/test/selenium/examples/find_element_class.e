note
	description: "Using the class attribute to find elements. The class attribute is provided to apply CSS to an element."

class
	FIND_ELEMENT_CLASS

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature

	default_create
		do
			search
		end

feature -- Search by id

	search
		local
			web_driver: WEB_DRIVER
			wait: WEB_DRIVER_WAIT
			capabilities : SE_CAPABILITIES
		do
				-- Create desired capabilities

			create capabilities.make
			capabilities.set_css_selectors_enabled (True)
			capabilities.set_browser_name ("chrome")

				--Create a new instance of a Web driver
			create web_driver.make

				-- Start session with chrome and capabilities
			web_driver.start_session_chrome_with_desired_capabilities (capabilities)

				-- Go to EiffelRoom login page
			web_driver.to_url ("http://www.eiffelroom.com/user?destination=front")


				-- Find the user name, password element by its id and submit
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).id ("edit-name")) as l_user and then attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).id ("edit-pass")) as l_pass and then attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).id ("edit-submit")) as l_form then
				l_user.send_keys (<<"test">>)
				l_pass.send_keys (<<"pass">>)
				l_form.submit
			end

				-- After submit, there is an error message, and we still are in the same page

			-- Wait for the page to load, timeout after 10 seconds
		   	 create wait.make (web_driver,10)
			 wait.until_when (agent expected_title (web_driver, "User account"))


			if attached web_driver.get_page_tile as l_title then
				print ("%NPage title is:" + l_title)
			end

			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).class_name ("title")) as l_title then
				if attached l_title.get_text as l_text then
					print ("%NDisplay:" +  l_text)

				end
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
