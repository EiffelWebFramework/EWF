note
	description: "[

	]"

class
	FIND_ELEMENTS_LINKS

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

			 create wait.make (web_driver,10)
			 wait.until_when (agent expected_title (web_driver, "Eiffel Room"))


				-- Find links
			if attached {ARRAYED_LIST[WEB_ELEMENT]}web_driver.find_elements ((create {SE_BY}).tag_name("a")) as l_links  then
				from
					l_links.start
				until
					l_links.after
				loop
					if attached l_links.item.get_attribute ("href") as l_ref then
						print ("%Nhref:" + l_ref)
					end
					l_links.forth
				end
			end
			print ("%Nend process ..." )
			io.read_line
				-- close the window
			web_driver.window_close
		end

end
