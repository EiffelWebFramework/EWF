note
	description: "Summary description for {SE_COOKIE_JSON_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_COOKIE_JSON_CONVERTER
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

	object: SE_COOKIE

feature -- Conversion

	from_json (j: like to_json): detachable like object
		do
			create Result
			if attached {STRING_32} json_to_object (j.item (name_key), Void) as l_item then
				Result.set_name(l_item)
			end
			if attached {STRING_32} json_to_object (j.item (value_key), Void) as l_item then
				Result.set_value(l_item)
			end
			if attached {STRING_32} json_to_object (j.item (path_key), Void) as l_item then
				Result.set_path(l_item)
			end
			if attached {STRING_32} json_to_object (j.item (domain_key), Void) as l_item then
				Result.set_domain(l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (secure_key), Void) as l_item then
				if l_item then
					Result.secure
				end
			end
			if attached {INTEGER_32} json_to_object (j.item (expiry_key), Void) as l_item then
					Result.set_expiry (l_item.as_natural_32)
			end

		end

	to_json (o: like object): JSON_OBJECT
		do
			create Result.make
			Result.put (json.value (o.name), name_key)
			Result.put (json.value (o.value), value_key)
			Result.put (json.value (o.path), path_key)
			Result.put (json.value (o.domain), domain_key)
			Result.put (json.value (o.is_secure), secure_key)
			Result.put (json.value (o.expiry), expiry_key)
		end

feature {NONE} -- Implementation



	name_key: JSON_STRING
		once
			create Result.make_json ("name")
		end

	value_key: JSON_STRING
		once
			create Result.make_json ("value")
		end

	path_key: JSON_STRING
		once
			create Result.make_json ("path")
		end

	domain_key: JSON_STRING
		once
			create Result.make_json ("domain")
		end

	secure_key : JSON_STRING
		once
			create Result.make_json ("secure")
		end

	expiry_key : JSON_STRING
		once
			create Result.make_json ("expiry")
		end


end
