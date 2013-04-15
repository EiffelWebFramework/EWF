note
	description: "A converter for SE_STATUS"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_STATUS_JSON_CONVERTER

inherit
	SE_JSON_CONVERTER

create
	make

feature {NONE} -- Initialization

	make
		do
			create object
		end

feature -- Access

	object: SE_STATUS

feature -- Conversion

	from_json (j: like to_json): detachable like object
		do
			create Result
			if attached {INTEGER_32} json_to_object (j.item (status_key), Void) as l_ucs then
				Result.set_status (l_ucs)
			end
			if attached {STRING_32} json_to_object (j.item (session_id_key), Void) as l_ucs then
				Result.set_session_id (l_ucs)
			end
			if attached {STRING_32} json_to_object (j.item (state_key), Void) as l_ucs then
				Result.set_state (l_ucs)
			end
			if attached {STRING_32} json_to_object (j.item (class_name_key), Void) as l_ucs then
				Result.set_class_name (l_ucs)
			end
			if attached {INTEGER_32} json_to_object (j.item (hash_code_key), Void) as l_ucs then
				Result.set_hash_code (l_ucs.out)
			end
			if attached {SE_STATUS_VALUE} json_to_object (j.item (value_key), {SE_STATUS_VALUE}) as lv then
				Result.set_value(lv)
			end
		end

	to_json (o: like object): JSON_OBJECT
		do
			create Result.make
			Result.put (json.value (o.status), status_key)
			Result.put (json.value (o.session_id), session_id_key)
			Result.put (json.value (o.value), value_key)
			Result.put (json.value (o.state), state_key)
			Result.put (json.value (o.class_name), class_name_key)
			Result.put (json.value (o.hash_code), hash_code_key)
		end

feature {NONE} -- Implementation




	status_key: JSON_STRING
		once
			create Result.make_json ("status")
		end

	session_id_key: JSON_STRING
		once
			create Result.make_json ("sessionId")
		end

	value_key: JSON_STRING
		once
			create Result.make_json ("value")
		end

	state_key: JSON_STRING
		once
			create Result.make_json ("state")
		end

	class_name_key: JSON_STRING
		once
			create Result.make_json ("class")
		end

	hash_code_key : JSON_STRING
		once
			create Result.make_json ("hCode")
		end

note
	copyright: "2011-2012, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
