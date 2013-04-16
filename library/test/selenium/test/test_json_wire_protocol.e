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

feature {NONE}-- Implementation
	wire_protocol: SE_JSON_WIRE_PROTOCOL
		once
			create Result.make
		end

	session_id: detachable STRING_32

end
