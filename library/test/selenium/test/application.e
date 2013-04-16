note
	description : "test application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		local
			web_driver: SE_JSON_WIRE_PROTOCOL
			capabilities : SE_CAPABILITIES
			timeout : SE_TIMEOUT_TYPE
		do
			-- check if the selenium Remote WebDriver is up and running.
			create web_driver.make
			if attached web_driver.status as l_status  then
				print (l_status)



				-- create a new session
				create capabilities.make
				capabilities.set_browser_name ("chrome")
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session then
					print ("%NSessionId:" + l_session.session_id)
				end


				-- create a new session
				create capabilities.make
				capabilities.set_browser_name ("chrome")
				if attached web_driver.create_session_with_desired_capabilities (capabilities) as l_session then
					print ("%NSessionId:" + l_session.session_id)
					create timeout.make_empty
					web_driver.set_session_timeouts (l_session.session_id, timeout)
				end


				-- retrieve sessions
				if attached web_driver.sessions as l_session then
					across l_session as l_item loop
						print (l_item)
					end
				end

			else
				print ("The selenium server is not accesible")
			end

		end

	test_session
		local
				h: LIBCURL_HTTP_CLIENT
				session: HTTP_CLIENT_SESSION
				resp : detachable HTTP_CLIENT_RESPONSE
				l_location : detachable READABLE_STRING_8
				body : STRING
				context : HTTP_CLIENT_REQUEST_CONTEXT
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
				resp := session.post ("session", context,s)
				print(resp)
		end
end
