indexing
	description: "JSON Truth values"
	author: "Javier Velilla"
	date: "2008/08/24"
	revision: "Revision 0.1"

class

	JSON_BOOLEAN

inherit
	JSON_VALUE

create

	make_boolean

feature -- Initialization

	make_boolean (an_item: BOOLEAN) is
			--Initialize.
		do
			item := an_item
		end

feature -- Access

	item: BOOLEAN
		-- Content


	hash_code: INTEGER is
			--Hash code value
		do
			Result := item.hash_code
		end

feature -- Visitor pattern

	accept (a_visitor: JSON_VISITOR) is
			-- Accept `a_visitor'.
			-- (Call `visit_json_boolean' procedure on `a_visitor'.)
		do
			a_visitor.visit_json_boolean (Current)
		end



end
