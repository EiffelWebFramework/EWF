indexing

	description: "[
An JSON_OBJECT represent an object in JSON.
An object is an unordered set of name/value pairs

			Examples:

			object
			{}
			{"key","value"}


]"
			author: "Javier Velilla"
			date: "$Date$"
			revision: "$Revision$"
			license:"MIT (see http://www.opensource.org/licenses/mit-license.php)"


class

	JSON_OBJECT

inherit

	JSON_VALUE

create

	make

feature -- Initialization

	make is
			--
		do
			create object.make (10)
		end

feature -- Change Element


	put (value: JSON_VALUE ; key: JSON_STRING) is
			-- Assuming there is no item of key `key',
			-- insert `value' with `key'.
		require
			not_present: not has_key (key)
		local
			l_json_null: JSON_NULL
			l_value: JSON_VALUE
		do
			l_value:=value
			if value = void then
				create l_json_null
				l_value:=l_json_null
			end
			object.extend (l_value,key)
		end


feature -- Access

	has_key (key: JSON_STRING):BOOLEAN is
			-- has the JSON_OBJECT contains a specific key 'key'.
		do
			Result := object.has (key)
		end

	has_item (value: JSON_VALUE):BOOLEAN is
			-- has the JSON_OBJECT contain a specfic item 'value'
		do
			Result := object.has_item (value)
		end

	item (key: JSON_STRING):JSON_VALUE is
			-- the json_value associated with a key.
		do
			Result:= object.item (key)
		end

	current_keys: ARRAY [JSON_STRING] is
			-- array containing actually used keys
		do
			Result:=object.current_keys
		end


feature -- Report

	to_json: STRING is
			--  Printable json representation
			-- {} or {member}
			-- see documentation
		do
			create Result.make_empty
			Result.append ("{")
			from
				object.start
			until
				object.off
			loop
				Result.append (object.item_for_iteration.to_json)
				Result.append (":")
				Result.append (object.key_for_iteration.to_json)
				object.forth
				if not object.after then
					Result.append (",")
				end
			end
			Result.append ("}")
		end

	hash_code: INTEGER is
			-- Hash code value
		local
		do
			from
				object.start
				Result := object.item_for_iteration.hash_code
			until
				object.off
			loop
				Result := ((Result \\ 8388593) |<< 8)  + object.item_for_iteration.hash_code
				object.forth
			end
			-- Ensure it is a positive value.
			Result := Result.hash_code
		end


feature {NONE} -- Implementation

	object: HASH_TABLE[JSON_VALUE,JSON_STRING]

end
