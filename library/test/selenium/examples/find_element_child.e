note
	description: "The WEB_ELEMENT class also supports find methods that find child elements."

class
	FIND_ELEMENT_CHILD

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
			web_driver.to_url ("http://www.eiffelroom.com/")

				-- Find the element div with id page,and then we can find a child element div page-inner
				--<div id="page">
				--	<div id="page-inner">
				--		<a id="navigation-top" name="top"></a>
				--	<div id="skip-to-nav">
				--	<div id="header">
				--	<div id="main">
				--	<div id="footer">
				--	</div>
				--</div>		
			if attached {WEB_ELEMENT} web_driver.find_element ((create {SE_BY}).id ("page")) as l_div_page then
				print ("%N Page element id" + l_div_page.element)
				if attached {WEB_ELEMENT}l_div_page.find_element ((create {SE_BY}).id ("page-inner")) as l_div_page_inner	then
					print ("%N Inner Page element id" + l_div_page_inner.element)
				end
			end
				-- close the window
			web_driver.window_close
			print ("%N")
		end

end
