indexing
	description: "JSON Null Values"
	author: "Javier Velilla"
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_NULL
	inherit
		JSON_VALUE

feature --Access
	to_json:STRING is
			--
			do
			 Result:=null_value
			end

	hash_code:INTEGER is
			--
			do
				Result:= null_value.hash_code
			end

feature {NONE}-- Implementation		
	null_value:STRING is "null"
end
