note
	description: "[
		Advanced implementation of JSON_OBJECT with some helper	functions.
	]"
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

	put_string (value: detachable READABLE_STRING_GENERAL; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: detachable JSON_STRING
		do
			if attached value as a_value then
				create l_value.make_json_from_string_32 (a_value.as_string_32)
			end
			put (l_value, key)
		end

	put_integer (value: detachable INTEGER_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: detachable JSON_NUMBER
		do
			if attached value as a_value then
				create l_value.make_integer (a_value)
			end
			put (l_value, key)
		end

	put_natural (value: detachable NATURAL_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: detachable JSON_NUMBER
		do
			if attached value as a_value then
				create l_value.make_natural (a_value)
			end
			put (l_value, key)
		end

	put_real (value: detachable DOUBLE; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: detachable JSON_NUMBER
		do
			if attached value as a_value then
				create l_value.make_real (a_value)
			end
			put (l_value, key)
		end

	put_boolean (value: detachable BOOLEAN; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			key_not_present: not has_key (key)
		local
			l_value: detachable JSON_BOOLEAN
		do
			if attached value as a_value then
				create l_value.make_boolean (a_value)
			end
			put (l_value, key)
		end

	replace_with_string (value: detachable READABLE_STRING_GENERAL; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: detachable JSON_STRING
		do
			if attached value as a_value then
				create l_value.make_json_from_string_32 (value.as_string_32)
			end
			replace (l_value, key)
		end

	replace_with_integer (value: detachable INTEGER_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: detachable JSON_NUMBER
		do
			if attached value as a_value then
				create l_value.make_integer (a_value)
			end
			replace (l_value, key)
		end

	replace_with_with_natural (value: detachable NATURAL_64; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: detachable JSON_NUMBER
		do
			if attached value as a_value then
				create l_value.make_natural (a_value)
			end
			replace (l_value, key)
		end

	replace_with_real (value: detachable DOUBLE; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'
		local
			l_value: detachable JSON_NUMBER
		do
			if attached value as a_value then
				create l_value.make_real (a_value)
			end
			replace (l_value, key)
		end

	replace_with_boolean (value: detachable BOOLEAN; key: JSON_STRING)
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		local
			l_value: detachable JSON_BOOLEAN
		do
			if attached value as a_value then
				create l_value.make_boolean (a_value)
			end
			replace (l_value, key)
		end

end
