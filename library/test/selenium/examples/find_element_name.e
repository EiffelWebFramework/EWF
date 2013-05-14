note
	description: "[
		Unlike find_element_id, find by name attribute may not be unique on a page. We might find multiple elements 
		with similar name attributes,if that happends, the first element on the page 
		will be selected, which may not be the element we are looking for.
	]"

class
	FIND_ELEMENT_NAME

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
		do
				--Create a new instance of a Web driver
			create web_driver.make

				-- Start session with chrome
			web_driver.start_session_chrome

				-- Go to EiffelRoom login page
			web_driver.to_url ("http://www.eiffelroom.com/user?destination=front")

				-- Find the user name, password element by its name and submit
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).name ("name")) as l_user and then attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).name ("pass")) as l_pass and then attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).name ("op")) as l_form then
				l_user.send_keys (<<"test">>)
				l_pass.send_keys (<<"pass">>)
				l_form.submit
			end
			if attached web_driver.get_page_tile as l_title then
				print ("%NPage title is:" + l_title)
			end
				-- close the window
			web_driver.window_close
		end

end
