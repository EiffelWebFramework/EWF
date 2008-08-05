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

	make_boolean (an_item: BOOLEAN) is
			--
		do
			item := an_item
		end

feature -- Access

	item: BOOLEAN

	to_json: STRING is
			--
		do
			Result := item.out
		end

	hash_code: INTEGER is
			--
		do
			Result := item.hash_code
		end



end
