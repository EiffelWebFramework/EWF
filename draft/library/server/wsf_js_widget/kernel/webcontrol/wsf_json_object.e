note
	description: "[
		Advanced implementation of JSON_OBJECT with some helper	functions.
		This class can be removed since the proposed changes where merged in
		to https://github.com/eiffelhub/json
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

feature -- Change

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
		ensure
			has_key: has_key (key)
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
		ensure
			has_key: has_key (key)
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
		ensure
			has_key: has_key (key)
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
		ensure
			has_key: has_key (key)
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
		ensure
			has_key: has_key (key)
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

note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
