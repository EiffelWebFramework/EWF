note
	description: "A JSON converter for LINKED_LIST [ANY]"
	author: "Paul Cohen"
	date: "$Date$"
	revision: "$Revision$"
	file: "$HeadURL: $"

class
	JSON_LINKED_LIST_CONVERTER

inherit

	JSON_LIST_CONVERTER
		redefine
			object
		end

create
	make

feature -- Access

	object: LINKED_LIST [detachable ANY]

feature {NONE} -- Factory

	new_object (nb: INTEGER): like object
		do
			create Result.make
		end

end -- class JSON_LINKED_LIST_CONVERTER
