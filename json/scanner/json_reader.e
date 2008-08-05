indexing

	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class

	JSON_READER

create

	make

feature -- Initialization

	make (a_json: STRING) is
			--
		do
			representation := a_json
			index := 1
		end


feature -- Commands

	read: CHARACTER is
			--
		do
			if not representation.is_empty then
				Result := representation.item (index)
			end
		end

	has_next: BOOLEAN is
			--
		do
			if index <= representation.count then
				Result := True
			end
		end

	has_previous: BOOLEAN is
			--
		do
			if index >=1  then
				Result := True
			end
		end

	next is
			--
		require
			has_more_elements: has_next
		do
			index := index + 1
		ensure
			incremented: old index + 1 = index
		end

	previous is
			--
		require
			not_is_first: has_previous
		do
			index := index - 1
		ensure
			incremented: old index - 1 = index
		end


	skip_withe_spaces is
			-- Remove withe spaces
		do
			from
			until not actual.is_space or not has_next
			loop
				next
			end
		end

	json_substring (start_index, end_index: INTEGER_32): STRING is
			--
		do
			Result := representation.substring (start_index, end_index)
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
