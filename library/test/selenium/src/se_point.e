note
	description: "Summary description for {SE_POINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_POINT

create
	default_create,
	make_with_values

feature -- Initialization

	make_with_values (new_x : INTEGER_32; new_y : INTEGER_32)
		do
			set_x (new_x)
			set_y (new_y)
		end

feature -- Access

	x : INTEGER_32
	y : INTEGER_32

		-- The X and Y coordinates for the element.

feature -- Change Element

	set_x (an_x : INTEGER_32)
		do
			x := an_x
		end

	set_y (an_y : INTEGER_32)
		do
			y := an_y
		end

end
