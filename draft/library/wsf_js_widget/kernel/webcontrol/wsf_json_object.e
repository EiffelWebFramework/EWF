note
	description: "Summary description for {WSF_JSON_OBJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_JSON_OBJECT

inherit

	JSON_OBJECT

create
	make

feature

	put_string (value: READABLE_STRING_GENERAL; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: JSON_STRING
		do
			create l_value.make_json_from_string_32 (value.as_string_32)
			put (l_value, key)
		end

	put_integer (value: INTEGER_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: JSON_NUMBER
		do
			create l_value.make_integer (value)
			put (l_value, key)
		end

	put_natural (value: NATURAL_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: JSON_NUMBER
		do
			create l_value.make_natural (value)
			put (l_value, key)
		end

	put_real (value: DOUBLE; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: JSON_NUMBER
		do
			create l_value.make_real (value)
			put (l_value, key)
		end

	put_boolean (value: BOOLEAN; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: JSON_BOOLEAN
		do
			create l_value.make_boolean (value)
			put (l_value, key)
		end

	replace_with_string (value: READABLE_STRING_GENERAL; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: JSON_STRING
		do
			create l_value.make_json_from_string_32 (value.as_string_32)
			replace (l_value, key)
		end

	replace_with_integer (value: INTEGER_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: JSON_NUMBER
		do
			create l_value.make_integer (value)
			replace (l_value, key)
		end

	replace_with_with_natural (value: NATURAL_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: JSON_NUMBER
		do
			create l_value.make_natural (value)
			replace (l_value, key)
		end

	replace_with_real (value: DOUBLE; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: JSON_NUMBER
		do
			create l_value.make_real (value)
			replace (l_value, key)
		end


	replace_with_boolean (value: BOOLEAN; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: JSON_BOOLEAN
		do
			create l_value.make_boolean (value)
			replace (l_value, key)
		end

end
