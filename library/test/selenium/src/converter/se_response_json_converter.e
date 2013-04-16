note
	description: "Summary description for {SE_RESPONSE_JSON_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_RESPONSE_JSON_CONVERTER
inherit
	SE_JSON_CONVERTER

create
	make

feature {NONE} -- Initialization

	make
		do
			create object.make_empty
		end

feature -- Access

	object: SE_RESPONSE

feature -- Conversion

	from_json (j: like to_json): detachable like object
		do
			create Result.make_empty
			if attached {STRING_32} json_to_object (j.item (session_key), Void) as l_item then
				Result.set_session_id(l_item)
			end
			if attached {INTEGER_8} json_to_object (j.item (status_key), Void) as l_item then
				Result.set_status(l_item)
			end
			if attached {JSON_VALUE}  j.item (value_key) as l_item then
				Result.set_value(l_item.representation)
			end



		end

	to_json (o: like object): JSON_OBJECT
		do
			create Result.make
			Result.put (json.value (o.session_id),session_key)
			Result.put (json.value (o.status), status_key)
			Result.put (json.value (o.value), value_key)
		end

feature {NONE} -- Implementation



	session_key: JSON_STRING
		once
			create Result.make_json ("sessionId")
		end

	status_key: JSON_STRING
		once
			create Result.make_json ("status")
		end

	value_key: JSON_STRING
		once
			create Result.make_json ("value")
		end


end
