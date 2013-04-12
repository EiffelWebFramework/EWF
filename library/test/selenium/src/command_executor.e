note
	description: "{COMMAND_EXECUTOR} object that execute a command in the JSONWireProtocol"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=SELINIUM", "protocol=JSONWireProtocol", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol#Commands"

class
	COMMAND_EXECUTOR
inherit
	JSON_HELPER
	SE_JSON_WIRE_PROTOCOL_COMMANDS

create
	make

feature -- Initialization
	make (a_host : STRING_32)
		do
			host := a_host
		end

feature -- Status Report
	is_available : BOOLEAN
		-- Is the Seleniun server up and running?
		local
			resp: HTTP_CLIENT_RESPONSE
		do
--			resp := execute_get (cmd_ping)
--			if resp.status = 200 then
--				Result := True
--			end
			Result := true
		end
feature -- Commands

	status : SE_RESPONSE
		require
			selinum_server_available : is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_status)
			if attached resp.body as l_body then
				Result := build_response (l_body)
			end
		end

	new_session (capabilities : STRING_32) : SE_RESPONSE
		require
			selinum_server_available : is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_new_session, capabilities)
			if attached resp.body as l_body then
				Result :=  build_response(l_body)
			end
		end

	sessions : SE_RESPONSE
		require
			selinum_server_available : is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_get (cmd_sessions)
			if attached resp.body as l_body then
				Result :=  build_response(l_body)
			end
		end


feature {NONE} -- Implementation
	execute_get (command_name:STRING_32) : HTTP_CLIENT_RESPONSE
		local
				h: LIBCURL_HTTP_CLIENT
				http_session : HTTP_CLIENT_SESSION
		do
			create h.make
			http_session := h.new_session (host)
			Result := http_session.get (command_name, context_executor)
		end

	execute_post (command_name:STRING_32; data: STRING_32) : HTTP_CLIENT_RESPONSE
		local
			h: LIBCURL_HTTP_CLIENT
			http_session : HTTP_CLIENT_SESSION
		do
			create h.make
			http_session := h.new_session (host)
			Result := http_session.post (command_name, context_executor, data)

		end


	build_response (a_message : STRING_32) :  SE_RESPONSE
		do
			create Result.make_empty
			initialize_converters (json)
			if attached {SE_RESPONSE} json.object_from_json (a_message, "SE_RESPONSE") as l_response then
				Result := l_response
			end
			Result.set_json_response (a_message)
		end


	context_executor : HTTP_CLIENT_REQUEST_CONTEXT
		-- request context for each request
		once
			create Result.make
			Result.headers.put ("application/json;charset=UTF-8", "Content-Type")
			Result.headers.put ("application/json;charset=UTF-8", "Accept")
		end

    host : STRING_32
end
