indexing

	description:"[
		A JSON_STRING represent a string in JSON.
		A string is a collection of zero or more Unicodes characters, wrapped in double
		quotes, using blackslash espaces.
		]"

	author: "Javier Velilla"
	date: "$Date$"
	revision: "$Revision$"
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

feature -- Initialization

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


feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is JSON_STRING  made of same character sequence as `other'
			-- (possibly with a different capacity)?
		do
			Result := Current.to_json.is_equal (other.to_json)
		end

feature -- Change Element

	append (an_item: STRING)is
			--
		do
			item.append_string (an_item)
		end


feature -- Status report

	to_json: STRING is
			--
		do
			create	Result.make_empty
			Result.append ("%"")
			Result.append (item)
			Result.append ("%"")
		end

	hash_code: INTEGER is
			--
		do
			Result := item.hash_code
		end

invariant

	value_not_void: item /= Void

end
