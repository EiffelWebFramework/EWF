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


	put(key:JSON_STRING; value:JSON_VALUE) is
			--
			local
				l_json_null:JSON_NULL
				l_value:JSON_VALUE
			do
				l_value:=value
				if value = void then
					create l_json_null
					l_value:=l_json_null
				end
				object.extend(key, l_value)
			end


feature -- Report
	to_json:STRING is
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


feature -- Implementation
	object:HASH_TABLE[JSON_STRING,JSON_VALUE]
end
