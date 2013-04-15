note
	description: "Summary description for {SE_TIMEOUT_TYPE_JSON_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_TIMEOUT_TYPE_JSON_CONVERTER
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

	object: SE_TIMEOUT_TYPE
	
feature -- Conversion

	from_json (j: like to_json): detachable like object
		do
			create Result.make_empty
			if attached {STRING_32} json_to_object (j.item (type_key), Void) as l_item then
				Result.set_type(l_item)
			end
			if attached {INTEGER_32} json_to_object (j.item (ms_key), Void) as l_item then
				Result.set_ms (l_item)
			end
		end

	to_json (o: like object): JSON_OBJECT
		do
			create Result.make
			Result.put (json.value (o.type),type_key)
			Result.put (json.value (o.ms), ms_key)
		end

feature {NONE} -- Implementation


	type_key: JSON_STRING
		once
			create Result.make_json ("type")
		end

	ms_key: JSON_STRING
		once
			create Result.make_json ("ms")
		end


end
