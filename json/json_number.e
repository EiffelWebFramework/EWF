indexing

	description: "JSON Numbers, octal and hexadecimal formats are not used."
	author: "Javier Velilla"
	date: "$Date$"
	revision: "$Revision$"
	license:"MIT (see http://www.opensource.org/licenses/mit-license.php)"

class
	JSON_NUMBER

inherit

	JSON_VALUE
		rename
			is_equal as is_equal_json_value
		end
create

	make_integer,
	make_real

feature -- initialization

	make_integer (argument: INTEGER) is
		do
			item:= argument.out
			internal_hash_code:=argument.hash_code
			numeric_type:= "INTEGER"
		end

	make_real (argument: REAL) is
		do
			item:= argument.out
			internal_hash_code:=argument.hash_code
			numeric_type:= "REAL"
		end


feature -- Access

	item: STRING

	hash_code: INTEGER is
			--
		do
			Result:=internal_hash_code
		end


feature -- Status

	is_equal (other: like Current): BOOLEAN is
			-- Is `other' attached to an object of the same type
			-- as current object and identical to it?
		do
			Result:=item.is_equal (other.to_json)
		end

feature -- Conversion

	to_json: STRING is
			--
		do
			Result := item
		end


feature -- Implementation

	internal_hash_code: INTEGER

	numeric_type: STRING  -- REAL or INTEGER


invariant

	item_not_void: item /= Void

end
