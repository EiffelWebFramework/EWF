indexing
	description: "JSON Truth values"
	author: "Javier Velilla"
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_BOOLEAN
		inherit
		JSON_VALUE

create
	make_boolean
feature -- Initialization

	make_boolean(a_value:BOOLEAN) is
			--
			do
				value:=a_value
			end

feature -- Access

	to_json:STRING is
			--
			do
				Result:=value.out
			end

	hash_code:INTEGER is
			--
			do
				Result:=value.hash_code
			end


 	value:BOOLEAN

end
