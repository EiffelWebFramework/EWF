note
	description: "Object representation of JSON response describing the state of the server"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=status", "protocol=http", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol#GET_/status"

class
	SE_STATUS
inherit
	ANY
		redefine
			out
		end

feature -- Access
	status: INTEGER_32
    session_id: detachable STRING_32
	state: detachable STRING_32
    class_name: detachable STRING_32
    value : detachable  SE_STATUS_VALUE
    hash_code: detachable STRING_32

feature -- Change Element
	set_status (a_status : INTEGER_32)
		do
			status := a_status
		end

	set_session_id (a_session_id : STRING_32)
		do
			session_id := a_session_id
		end

	set_state (a_state : STRING_32)
		do
			state := a_state
		end

	set_class_name (a_class_name : STRING_32)
		do
			class_name := a_class_name
		end

	set_value (a_value : SE_STATUS_VALUE)
		do
			value := a_value
		end

	set_hash_code (a_hash_code : STRING_32)
		do
			hash_code := a_hash_code
		end

	out : STRING
		do
			create Result.make_from_string ("Response : ")
			Result.append ("[Status:")
			Result.append (status.out)
			Result.append ("]")
			Result.append (" ")

			if attached session_id as l_session_id then
				Result.append ("[SessionId:")
				Result.append (l_session_id.out)
				Result.append ("]")
				Result.append (" ")
			end
			if attached state as l_state then
				Result.append ("[State:")
				Result.append (l_state.out)
				Result.append ("]")
				Result.append (" ")
			end
			if attached value as l_value then
				Result.append ("[value:")
				Result.append (l_value.out)
				Result.append ("]")
				Result.append (" ")
			end

			if attached class_name as l_class_name then
				Result.append ("[Class Name:")
				Result.append (l_class_name.out)
				Result.append ("]")
				Result.append (" ")
			end

			if attached hash_code as l_hash_code then
				Result.append ("[hCode:")
				Result.append (l_hash_code.out)
				Result.append ("]")
				Result.append (" ")
			end


		end
end
