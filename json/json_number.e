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
			rename is_equal as is_equal_json_value
           end
create
	make_integer,
	make_real

feature -- initialization
	make_integer(argument:INTEGER) is
			do
				value:= argument.out
				internal_hash_code:=argument.hash_code
				numeric_type:="INTEGER"
			end

	make_real(argument:REAL) is
			do
				value:= argument.out
				internal_hash_code:=argument.hash_code
				numeric_type:="REAL"
			end


feature -- Access
	to_json:STRING is
			--
			do
				Result:=value
			end

	hash_code:INTEGER is
			--
		do
			Result:=internal_hash_code
		end


	is_equal (other: like Current): BOOLEAN is
			-- Is `other' attached to an object of the same type
			-- as current object and identical to it?
		do
			Result:=value.is_equal(other.to_json)
		end

feature -- Implementation
	value:STRING
	internal_hash_code:INTEGER
	numeric_type:STRING  -- REAL or INTEGER
end
