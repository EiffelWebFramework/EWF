note
	description: "Summary description for {SE_JAVA_VALUE_JSON_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_JAVA_VALUE_JSON_CONVERTER
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

	object: SE_JAVA_VALUE

feature -- Conversion

	from_json (j: like to_json): detachable like object
		do
			create Result.make_empty
			if attached {STRING_32} json_to_object (j.item (version_key), Void) as l_item then
				Result.set_version(l_item)
			end
		end

	to_json (o: like object): JSON_OBJECT
		do
			create Result.make
			Result.put (json.value (o.version), version_key)
		end

feature {NONE} -- Implementation



	version_key: JSON_STRING
		once
			create Result.make_json ("version")
		end

end
