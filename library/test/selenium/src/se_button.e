note
	description: "Summary description for {SE_BUTTON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_BUTTON
inherit {NONE}
	ENUM


create
	make_left,
	make_middle,
	make_right


feature -- Initialization

	make_left
		do
			set_left
		end

	make_middle
		do
			set_middle
		end

	make_right
		do
			set_right
		end


feature -- Access

	is_valid_value (a_value: INTEGER): BOOLEAN
			-- Can `a_value' be used in a `set_value' feature call?
		do
			Result := (a_value = left_value) or else
					  (a_value = middle_value) or else
					  (a_value = right_value)
		end

feature -- Element Change

	set_left
			do
				value :=  left_value
			end

	set_middle
		do
			value := middle_value
		end

	set_right
		do
			value := right_value
		end


feature -- Query

	is_left : BOOLEAN
			-- is the current value left?
		do
			Result := (value = left_value)
		end

	is_middle  : BOOLEAN
		-- is the current value middle?
		do
			Result := (value = middle_value)
		end


	is_right  : BOOLEAN
		-- is the current value right?
		do
			Result := (value = right_value)
		end


feature  {NONE} -- Implementation
--	{LEFT = 0, MIDDLE = 1 , RIGHT = 2}
	left_value :INTEGER = 0
	middle_value : INTEGER = 1
	right_value : INTEGER = 2
end



