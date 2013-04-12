note
	description: "Summary description for {SE_JSON_WIRE_PROTOCOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=SELINIUM", "protocol=http", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol"

class
	SE_JSON_WIRE_PROTOCOL

inherit

	JSON_HELPER

	SE_JSON_WIRE_PROTOCOL_COMMANDS

create
	make, make_with_host

feature -- Initialization

	make
			--
		local
			h: LIBCURL_HTTP_CLIENT
		do
			create h.make
			host := "http://127.0.0.1:4444/wd/hub/"
			initialize_executor
		end

	make_with_host (a_host: STRING_32)
			--
		local
			h: LIBCURL_HTTP_CLIENT
		do
			create h.make
			host := a_host
			initialize_executor
		end

feature -- Commands

	status: detachable SE_STATUS
			-- GET /status
			-- Query the server's current status.
			-- The server should respond with a general "HTTP 200 OK" response if it is alive and accepting commands.
			-- The response body should be a JSON object describing the state of the server.
			-- All server implementations should return two basic objects describing the server's current platform and when the server was built.
			-- All fields are optional; if omitted, the client should assume the value is uknown.
			-- Furthermore, server implementations may include additional fields not listed here.
		local
			response : SE_RESPONSE
		do
			if commnad_executor.is_available then

				response := commnad_executor.status
				if attached response.json_response as l_response then
					Result := json_to_se_status (l_response)
				end
			else
				-- TODO log the error.
				-- Handling error
				-- the Selenium server is not running or not it is reachable	
			end
		end

	create_session_with_desired_capabilities (capabilities: SE_CAPABILITIES): detachable SE_SESSION
			--	POST /session
			--  Create a new session.
			--  The server should attempt to create a session that most closely matches the desired and required capabilities.
			--	Required capabilities have higher priority than desired capabilities and must be set for the session to be created.
			--		JSON Parameters:
			--			desiredCapabilities - {object} An object describing the session's desired capabilities.
			--			requiredCapabilities - {object} An object describing the session's required capabilities (Optional).
			--		Returns:
			--			A 302 See Other redirect to /session/:sessionId, where :sessionId is the ID of the newly created session.
			--		Potential Errors:
			--			SessionNotCreatedException - If a required capability could not be set.
		local
			response : SE_RESPONSE
		do
			-- TODO, update the status of the server
			-- SE_STATUS
			-- SE_ERROR
			-- create an COMMAND_EXECUTOR
			if commnad_executor.is_available then

				if attached to_json (capabilities) as l_json then
					response := commnad_executor.new_session(desired_capabilities (l_json.representation))
					if attached response.json_response as r_value then
						Result := build_session (r_value)
					end
				end
			else
			end
		end


	sessions : detachable LIST[SE_SESSION]
		-- GET /sessions
		-- Returns a list of the currently active sessions. Each session will be returned as a list of JSON objects with the following keys:
		--	id	 string	 The session ID.
		--	capabilities	 object	 An object describing the session's capabilities.
		local
			response : SE_RESPONSE
			index : INTEGER
		do
			if commnad_executor.is_available then
				response := commnad_executor.sessions
				if attached response.value as l_value and then attached {JSON_ARRAY} string_to_json (l_value) as l_json_array then
					create {ARRAYED_LIST[SE_SESSION]} Result.make (10)
					from
						index := 1
					until
						index > l_json_array.count
					loop
						if attached {JSON_OBJECT} l_json_array.i_th (index) as json_obj then
							if attached build_session (json_obj.representation) as l_session  then
								Result.force ( l_session)
							end
						end
						index := index + 1
					end
				end
			else
				-- TODO handle error
			end

		end

feature {NONE} -- Implementation
	initialize_executor
		do
			create commnad_executor.make ( host )
		end

	host: STRING_32

	desired_capabilities (capabilites: STRING_32): STRING_32
		do
			create Result.make_from_string (desired_capabilities_template)
			Result.replace_substring_all ("$DESIRED_CAPABILITIES", capabilites)
		end

	desired_capabilities_template: STRING = "[
					{
			 	  	 "desiredCapabilities": $DESIRED_CAPABILITIES
			 	  	}
		]"

	commnad_executor : COMMAND_EXECUTOR

	build_session (value : STRING_32): detachable SE_SESSION
		do
			if  attached  {JSON_OBJECT} string_to_json (value) as l_value then
				if attached l_value.item ("sessionId") as ls and then attached l_value.item ("value") as lv and then attached json_to_se_capabilities (lv.representation) as lc then
					create Result.make (ls.representation, lc)
				end
			end
		end
end
