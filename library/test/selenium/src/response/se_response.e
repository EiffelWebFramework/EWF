note
	description: "Object that represent Command responses from Seleniun JSONWireProtocol"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=SELINIUM", "protocol=JsonWireProtocol", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol#Responses"

class
	SE_RESPONSE

create
	make,
	make_empty

feature -- Initialization
	make (a_session_id : STRING_32; a_status: INTEGER_32; a_value : STRING_32)
		do
			session_id := a_session_id
			status := a_status
			value := a_value
		end

	make_empty
		do

		end
feature -- Access
	session_id : detachable STRING_32
		-- An opaque handle used by the server to determine where to route session-specific commands.
		-- This ID should be included in all future session-commands in place of the :sessionId path segment variable.

	status : INTEGER_32
		-- A status code summarizing the result of the command. A non-zero value indicates that the command failed.

	value : detachable STRING_32
		-- The response JSON value.

feature -- Change Element
	set_session_id ( a_session_id : STRING_32)
		do
			session_id := a_session_id
		end

	set_status ( a_status : INTEGER_32)
		do
			status := a_status
		end

	set_value (a_value : STRING_32)
		do
			value := a_value
		end

feature -- JSON Response
	json_response : detachable STRING_32

	set_json_response  ( a_response : STRING_32)
		do
			json_response := a_response
		end
end
