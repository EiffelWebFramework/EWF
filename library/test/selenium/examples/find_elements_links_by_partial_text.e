note
	description: "[

	]"

class
	FIND_ELEMENTS_LINKS_BY_PARTIAL_TEXT

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
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).partial_link_text("Eiffel")) as l_link  then
					if attached l_link.get_attribute ("href") as l_ref then
						print ("%Nhref:" + l_ref)
					end
			end
				-- <a href="#navigation">Skip to Navigation</a>
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).partial_link_text("Skip to")) as l_link  then
					if attached l_link.get_attribute ("href") as l_ref then
						print ("%Nhref:" + l_ref)
					end
			end
			print ("%Nend process ..." )
			io.read_line
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
