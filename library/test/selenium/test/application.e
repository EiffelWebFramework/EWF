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
		do
--			test_back_forward_refesh
--			test_status_sessions_timeout
			test_ime_actions
		end


	test_ime_actions
		local
			web_driver: SE_JSON_WIRE_PROTOCOL
			capabilities: SE_CAPABILITIES
			timeout: SE_TIMEOUT_TYPE

		do
			-- check if the selenium Remote WebDriver is up and running.
			create web_driver.make
			if attached web_driver.status as l_status then
				create capabilities.make
				capabilities.set_browser_name ("chrome")
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session then
					print ("%NSessionId:" + l_session.session_id)
					-- available engines
					if attached web_driver.ime_available_engines (l_session.session_id) as l_available then
						check
							has_no_error : not web_driver.has_error
						end
					else
					 	check	has_error : web_driver.has_error end
					 	-- ime_active_engine
					 	check
					 		no_active_engine : web_driver.ime_active_engine (l_session.session_id) = Void
					 		has_error : web_driver.has_error
					 	end
					 	-- ime_activated
					 	check
					 		no_active: not web_driver.ime_activated (l_session.session_id)
					 		has_error : web_driver.has_error
					 	end
					 	-- ime_deactivate
					 	web_driver.ime_deactivate (l_session.session_id)
					 	check
					 		has_error : web_driver.has_error
					 	end

					 	-- ime_activate
					 	web_driver.ime_activate (l_session.session_id,"UNKown")
					 	check
					 		has_error : web_driver.has_error
					 	end
					end
				end

				create capabilities.make
				capabilities.set_browser_name ("firefox")
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session then
					print ("%NSessionId:" + l_session.session_id)
					check
						no_error_firefox: not web_driver.has_error
					end
				end
			end
		end
	test_status_sessions_timeout
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
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session2 then
					print ("%NSessionId:" + l_session2.session_id)
				end

					-- retrieve sessions
				if attached web_driver.sessions as l_session then
					across
						l_session as l_item
					loop
						print (l_item)
					end
				end
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session2 then
					print ("%NSessionId:" + l_session2.session_id)
					create timeout.make ("script", 1)
					web_driver.set_session_timeouts (l_session2.session_id, timeout)
				end

			else
				print ("The selenium server is not accesible")
			end
		end

	test_back_forward_refesh
		local
			web_driver: SE_JSON_WIRE_PROTOCOL
			capabilities: SE_CAPABILITIES
			file : RAW_FILE
		do
				create web_driver.make
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
					if attached web_driver.screenshot (l_session.session_id) as l_screenshot then
						check
							Has_no_error: not web_driver.has_error
						end
						create file.make_with_name ("screenshot_"+l_session.session_id+".png")
						file.open_write
						file.putstring (l_screenshot)
						file.close
					end
				end
		end

		
	test_session
		local
			h: LIBCURL_HTTP_CLIENT
			session: HTTP_CLIENT_SESSION
			resp: detachable HTTP_CLIENT_RESPONSE
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
