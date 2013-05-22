note
	description: "[
	]"

class
	FIND_ELEMENT_XPATH

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
			xpath_expression : STRING_32
		do
				--Create a new instance of a Web driver
			create web_driver.make

				-- Start session with chrome
			web_driver.start_session_chrome

				-- Go to EiffelRoom home page
			web_driver.to_url ("http://www.eiffelroom.com/")


			--Xpath expression
			xpath_expression := "//*[@id='page']"
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).xpath (xpath_expression)) as l_path then
				print ("%NElement:" + l_path.element)
			end

			-- Images with Alt
			-- img[@alt]
			if attached {LIST[WEB_ELEMENT]}web_driver.find_elements ((create {SE_BY}).xpath ("//img[@alt]")) as l_paths then
				from
					l_paths.start
				until
					l_paths.after
				loop
					print ("%NElement:" + l_paths.item.element)
					l_paths.forth
				end
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
