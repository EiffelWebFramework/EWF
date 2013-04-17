note
	description: "test application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	ARGUMENTS


-- TODO start and stop selenium server from Eiffel.
create
	make

feature {NONE} -- Initialization

	make
		local
			web_driver: SE_JSON_WIRE_PROTOCOL
			capabilities: SE_CAPABILITIES
			timeout: SE_TIMEOUT_TYPE
		do
				-- check if the selenium Remote WebDriver is up and running.
			create web_driver.make
			if attached web_driver.status as l_status then
				print (l_status)



					-- create a new session
				create capabilities.make
				capabilities.set_browser_name ("chrome")
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session then
					print ("%NSessionId:" + l_session.session_id)
					web_driver.navigate_to_url (l_session.session_id, "http://www.google.com/")
					check
						Has_no_error: not web_driver.has_error
					end
					web_driver.navigate_to_url (l_session.session_id, "http://www.infoq.com/")
					check
						Has_no_error: not web_driver.has_error
					end
					web_driver.navigate_to_url (l_session.session_id, "http://www.yahoo.com/")
					check
						Has_no_error: not web_driver.has_error
					end

						--back
					web_driver.back (l_session.session_id)
					check
						Has_no_error: not web_driver.has_error
					end
					if attached web_driver.retrieve_url (l_session.session_id) as l_back_url then
						check
							Has_no_error: not web_driver.has_error
						end
						check
							expected_infoq: "http://www.infoq.com/" ~ l_back_url.out
						end
					end

						-- forward
					web_driver.forward (l_session.session_id)
					check
						Has_no_error: not web_driver.has_error
					end
					if attached web_driver.retrieve_url (l_session.session_id) as l_forward_url then
						check
							Has_no_error: not web_driver.has_error
						end
						check
							expected_yahoo: "http://www.yahoo.com/" ~ l_forward_url.out
						end
					end

						-- refresh
					web_driver.refresh (l_session.session_id)
					check
						Has_no_error: not web_driver.has_error
					end
				end
				-- create a new session
				create capabilities.make
				capabilities.set_browser_name ("chrome")
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session then
					print ("%NSessionId:" + l_session.session_id)
					create timeout.make ("script", 1)
					web_driver.set_session_timeouts (l_session.session_id, timeout)
				end

--					-- retrieve sessions
--				if attached web_driver.sessions as l_session then
--					across
--						l_session as l_item
--					loop
--						print (l_item)
--					end
--				end
			else
				print ("The selenium server is not accesible")
			end
		end

	test_session
		local
			h: LIBCURL_HTTP_CLIENT
			session: HTTP_CLIENT_SESSION
			resp: detachable HTTP_CLIENT_RESPONSE
			l_location: detachable READABLE_STRING_8
			body: STRING
			context: HTTP_CLIENT_REQUEST_CONTEXT
			s: READABLE_STRING_8
		do
			create h.make
			s := "[
					 	      {
				  		"desiredCapabilities" : {
							"browserName":"firefox"
				 				}
				 					}
			]"
			session := h.new_session ("http://localhost:4444/wd/hub/")
			create context.make
			context.headers.put ("application/json;charset=UTF-8", "Content-Type")
			context.headers.put ("application/json;charset=UTF-8", "Accept")
			resp := session.post ("session", context, s)
			print (resp)
		end

end
