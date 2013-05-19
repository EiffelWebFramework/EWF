note
	description: "[
	]"

class
	FIND_ELEMENT_CSS_SELECTOR

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
		do
				--Create a new instance of a Web driver
			create web_driver.make

				-- Start session with chrome
			web_driver.start_session_chrome

				-- Go to EiffelRoom home page
			web_driver.to_url ("http://www.eiffelroom.com/")

				-- Absolute Path
				-- <div id="header">
				-- html.js body.front div#page div#page-inner div#header

			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).css_selector ("html.js body.front div#page div#page-inner div#header")) as selector then
				print ("%NElement:" + selector.element)
			end

				-- Relative Path
				--
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).css_selector ("div#header")) as selector then
				print ("%NElement:" + selector.element)
			end
			print ("%Nend process ...")
			io.read_line
				-- close the window
			web_driver.window_close
		end

	expected_title (driver: WEB_DRIVER; title: STRING_32): BOOLEAN
		do
			if attached {STRING_32} driver.get_page_tile as l_title and then l_title.has_substring (title) then
				Result := True
			end
		end

end
