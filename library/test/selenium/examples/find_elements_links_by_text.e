note
	description: "[

	]"

class
	FIND_ELEMENTS_LINKS_BY_TEXT

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

				-- Go to EiffelRoom home page
			web_driver.to_url ("http://www.eiffelroom.com/")

				-- Find links
				-- <a href="http://www.eiffel.com">Eiffel.com</a></li><li><a>
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).link_text("Eiffel.com")) as l_link  then
					if attached l_link.get_attribute ("href") as l_ref then
						print ("%Nhref:" + l_ref)
					end
			end
			print ("%Nend process ..." )
			io.read_line
				-- close the window
			web_driver.window_close
		end

end
