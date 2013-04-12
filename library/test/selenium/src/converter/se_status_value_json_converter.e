note
	description: "Summary description for {SE_STATUS_VALUE_JSON_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_STATUS_VALUE_JSON_CONVERTER
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

	object: SE_STATUS_VALUE

feature -- Conversion

	from_json (j: like to_json): detachable like object
		do
			create Result.make_empty
			if attached {SE_OS_VALUE} json_to_object (j.item (os_key), {SE_OS_VALUE}) as l_item then
				Result.set_os_value(l_item)
			end
			if attached {SE_JAVA_VALUE} json_to_object (j.item (java_key), {SE_JAVA_VALUE}) as l_item then
				Result.set_java_value(l_item)
			end
			if attached {SE_BUILD_VALUE} json_to_object (j.item (build_key), {SE_BUILD_VALUE}) as l_item then
				Result.set_build_value(l_item)
			end

		end

	to_json (o: like object): JSON_OBJECT
		do
			create Result.make
			Result.put (json.value (o.os_value), os_key)
			Result.put (json.value (o.java_value), java_key)
			Result.put (json.value (o.build_value), build_key)
		end

feature {NONE} -- Implementation



	os_key: JSON_STRING
		once
			create Result.make_json ("os")
		end

	java_key: JSON_STRING
		once
			create Result.make_json ("java")
		end

	build_key: JSON_STRING
		once
			create Result.make_json ("build")
		end

end
