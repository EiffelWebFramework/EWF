note
	description: "Summary description for {SE_WINDOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_WINDOW
create
	default_create,
	make_with_values

feature -- Initialization

	make_with_values (a_width : NATURAL_32; a_height : NATURAL_32)
		do
			set_width (a_width)
			set_height (a_height)
		end

feature -- Access
	--width: number, height: number} The size of the window.
	width : NATURAL_32
	height : NATURAL_32
	x,y : INTEGER_32

feature -- Change Element
	set_width (a_width : NATURAL_32)
		do
			width := a_width
		end

	set_height (a_height : NATURAL_32)
		do
			height := a_height
		end

	set_x (an_x : INTEGER_32)
		do
			x := an_x
		end

	set_y (an_y : INTEGER_32)
		do
			y := an_y
		end

end
