note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_JSON_WIRE_PROTOCOL

inherit

	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
		local
			capabilities: SE_CAPABILITIES
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				session_id := l_session.session_id
			end
		end

	on_clean
			-- <Precursor>
		do
			if attached session_id as l_session_id then
				wire_protocol.delete_session (session_id)
			end
		end

feature -- Test routines

	test_status
			--
		do
			if attached {SE_STATUS} wire_protocol.status as l_status then
				assert ("No error", not wire_protocol.has_error)
				assert ("Expected status 0", l_status.status = 0)
				assert ("Expected sessionId", l_status.session_id = Void)
			end
		end

	test_seleniun_server_host_not_available
			--
		local
			l_wire_protocol: SE_JSON_WIRE_PROTOCOL
		do
			create l_wire_protocol.make_with_host ("http://127.0.0.1:4443/wd/hub/status")
			assert ("expected void", l_wire_protocol.status = Void)
		end

	test_create_valid_new_session
		local
			capabilities: SE_CAPABILITIES
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
			end
		end

	test_create_invalid_new_session
		local
			capabilities: SE_CAPABILITIES
			session: detachable SE_SESSION
		do
			create capabilities.make
			capabilities.set_browser_name ("invalid")
			session := wire_protocol.create_session_with_desired_capabilities (capabilities)
			assert ("Expected error", wire_protocol.has_error)
			assert ("Expected void", session = Void)
		end

	test_retrieve_sessions
		local
			sessions: detachable LIST [SE_SESSION]
		do
			sessions := wire_protocol.sessions
			assert ("Not void", sessions /= Void)
			assert ("One or more items:", sessions.count >= 1)
		end


	test_delete_session
		local
			capabilities: SE_CAPABILITIES
			session : detachable SE_SESSION
			pre_session, post_session : INTEGER
		do
--			if attached wire_protocol.sessions as l_sessions then
--				pre_session := l_sessions.count
--			end

--			if attached session_id as l_session_id then
--				wire_protocol.delete_session (session_id)
--			end

--			if attached wire_protocol.sessions as l_sessions then
--				post_session := l_sessions.count
--			end

--			assert ("After delete Pre sesssion - 1 is equal to post_session", (pre_session - 1) = post_session)
		end

	test_valid_session_timeouts
		local
			l_timeout :SE_TIMEOUT_TYPE
			capabilities : SE_CAPABILITIES
		do
			create l_timeout.make ("script", 1)
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				wire_protocol.set_session_timeouts (l_session.session_id, l_timeout)
				assert ("Has no error", not wire_protocol.has_error)
			end
		end

	test_invalid_session_timeouts
		local
			l_timeout :SE_TIMEOUT_TYPE
			capabilities : SE_CAPABILITIES
		do
			create l_timeout.make ("tes", 1)
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				wire_protocol.set_session_timeouts (l_session.session_id, l_timeout)
				assert ("Has error", wire_protocol.has_error)
			end

		end

	test_valid_session_async_script_timeouts
		local
			capabilities : SE_CAPABILITIES
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				wire_protocol.set_session_timeouts_async_script (l_session.session_id, 1)
				assert ("Has no error", not wire_protocol.has_error)
			end
		end


	test_valid_session_implicit_wait_timeouts
		local
			capabilities : SE_CAPABILITIES
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				wire_protocol.set_session_timeouts_implicit_wait (l_session.session_id, 1)
				assert ("Has no error", not wire_protocol.has_error)
			end
		end


	test_retrieve_window_handle
		local
			capabilities : SE_CAPABILITIES
			window_handle : detachable STRING_32
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				window_handle := wire_protocol.retrieve_window_handle (l_session.session_id)
				assert ("Has no error", not wire_protocol.has_error)
				assert ("Windows handle not void", attached window_handle = True)
			end
		end


	test_retrieve_window_handles
		local
			capabilities : SE_CAPABILITIES
			window_handles : detachable LIST[STRING_32]
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				window_handles := wire_protocol.retrieve_window_handles (l_session.session_id)
				assert ("Has no error", not wire_protocol.has_error)
				assert ("Windows handleS not void", attached window_handles = True)
			end
		end

	test_retrieve_url
		local
			capabilities : SE_CAPABILITIES
			url : detachable STRING_32
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				url := wire_protocol.retrieve_url (session_id)
				assert ("Has no error", not wire_protocol.has_error)
				assert ("url not void", attached url = True)
			end
		end

	test_navigate_to_url
		local
			capabilities : SE_CAPABILITIES
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				wire_protocol.navigate_to_url (session_id,"http://www.google.com/")
				assert ("Has no error", not wire_protocol.has_error)
				if attached wire_protocol.retrieve_url (session_id) as l_url then
					assert("Expected url", "http://www.google.com/" ~ l_url.out)
				end
			end
		end


	test_back_and_forward
		local
			capabilities : SE_CAPABILITIES
		do
			create capabilities.make
			capabilities.set_browser_name ("chrome")
			capabilities.set_takes_screenshot (True)
			if attached wire_protocol.create_session_with_desired_capabilities (capabilities) as l_session then
				assert ("No error", not wire_protocol.has_error)
				wire_protocol.navigate_to_url (l_session.session_id,"http://www.google.com/")
				assert ("Has no error", not wire_protocol.has_error)
				wire_protocol.navigate_to_url (l_session.session_id,"http://www.infoq.com/")
				assert ("Has no error", not wire_protocol.has_error)
				wire_protocol.navigate_to_url (l_session.session_id,"http://www.yahoo.com/")
				assert ("Has no error", not wire_protocol.has_error)

				--back
				wire_protocol.back (l_session.session_id)
				assert ("Has no error", not wire_protocol.has_error)

				if attached wire_protocol.retrieve_url (l_session.session_id) as l_back_url then
					assert ("Has no error", not wire_protocol.has_error)
					assert ("Expected infoq", "http://www.infoq.com/" ~ l_back_url.out)
				end

				-- forward
				wire_protocol.forward (l_session.session_id)
				assert ("Has no error", not wire_protocol.has_error)

				if attached wire_protocol.retrieve_url (l_session.session_id) as l_forward_url then
					assert ("Has no error", not wire_protocol.has_error)
					assert ("Expected yahoo", "http://www.yahoo.com/" ~ l_forward_url.out)
				end

			end
		end

	test_ime_available_engines
		local
			capabilities : SE_CAPABILITIES
		do
			if attached wire_protocol.ime_available_engines (session_id) as l_ime_available_engines then
				assert ("Has no error", not wire_protocol.has_error)
				across l_ime_available_engines as item loop
					print (item)
				end
			else
				assert ("Has error :", wire_protocol.has_error)
				if attached wire_protocol.last_error as l_error then
					assert ("Status 13", l_error.code = 13)
				end
			end
		end


feature {NONE}-- Implementation
	wire_protocol: SE_JSON_WIRE_PROTOCOL
		once
			create Result.make
		end

	session_id: detachable STRING_32

end
