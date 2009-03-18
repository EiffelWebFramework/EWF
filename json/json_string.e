indexing

	description:"[
		A JSON_STRING represent a string in JSON.
		A string is a collection of zero or more Unicodes characters, wrapped in double
		quotes, using blackslash espaces.
		]"

	author: "Javier Velilla"
	date: "2008/08/24"
	revision: "Revision 0.1"
	license:"MIT (see http://www.opensource.org/licenses/mit-license.php)"


class
	JSON_STRING

inherit
	JSON_VALUE
		redefine
			is_equal
		end

create
	make_json

feature {NONE} -- Initialization

	make_json (an_item: STRING) is
			-- Initialize.
		require
			item_not_void: an_item /= Void
		do
			item := an_item
		end

feature -- Access

	item: STRING
			-- Contents

feature -- Visitor pattern

	accept (a_visitor: JSON_VISITOR) is
			-- Accept `a_visitor'.
			-- (Call `visit_json_string' procedure on `a_visitor'.)
		do
			a_visitor.visit_json_string (Current)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is JSON_STRING  made of same character sequence as `other'
			-- (possibly with a different capacity)?
		do
			Result := item.is_equal (other.item)
		end

feature -- Change Element

	append (a_string: STRING)is
			-- Add an_item
		require
			a_string_not_void: a_string /= Void
		do
			item.append_string (a_string)
		end

feature -- Status report

	hash_code: INTEGER is
			-- Hash code value
		do
			Result := item.hash_code
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := item
		end

invariant
	value_not_void: item /= Void

end
