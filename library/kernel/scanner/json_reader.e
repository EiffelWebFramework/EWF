indexing
	description: "Objects that ..."
	author: "jvelilla"
	date: "2008/08/24"
	revision: "0.1"

class
	JSON_READER

create
	make

feature {NONE} -- Initialization

    make (a_json: STRING) is
            -- Initialize Reader
        do
            set_representation (a_json)
        end

feature -- Commands

	 set_representation (a_json: STRING) is
            -- Set `representation'.
        do
        	a_json.left_adjust
        	a_json.right_adjust
		representation := a_json
            index := 1
        end

	read: CHARACTER is
			-- Read character
		do
			if not representation.is_empty then
				Result := representation.item (index)
			end
		end

	next is
			-- Move to next index
		require
			has_more_elements: has_next
		do
			index := index + 1
		ensure
			incremented: old index + 1 = index
		end

	previous is
			-- Move to previous index
		require
			not_is_first: has_previous
		do
			index := index - 1
		ensure
			incremented: old index - 1 = index
		end

	skip_white_spaces is
			-- Remove white spaces
		local
			c: like actual
		do
			from
				c := actual
			until
				(c /= ' ' and c /= '%N' and c /= '%R' and c /= '%U' and c /= '%T' ) or not has_next
			loop
				next
				c := actual
			end
		end

	json_substring (start_index, end_index: INTEGER_32): STRING is
			-- JSON representation between `start_index' and `end_index'
		do
			Result := representation.substring (start_index, end_index)
		end

feature -- Status report

	has_next: BOOLEAN is
			-- Has a next character?
		do
			Result := index <= representation.count
		end

	has_previous: BOOLEAN is
			-- Has a previous character?
		do
			Result := index >= 1
		end

feature -- Access

	representation: STRING
			-- Serialized representation of the original JSON string

feature {NONE} -- Implementation

	actual: CHARACTER is
			-- Current character or '%U' if none
		do
			if index > representation.count then
				Result := '%U'
			else
				Result := representation.item (index)
			end
		end

	index: INTEGER
			-- Actual index

invariant
	representation_not_void: representation /= Void

end
