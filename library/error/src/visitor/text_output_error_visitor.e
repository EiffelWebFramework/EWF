note
	description: "Text error output visitor"
	date: "$Date$"
	revision: "$Revision$"

class
	TEXT_OUTPUT_ERROR_VISITOR

inherit
	OUTPUT_ERROR_VISITOR
		redefine
			output_integer,
			output_new_line
		end

create
	make

feature -- Initialization

	make (buf: like buffer)
		require
			buf_attached: buf /= Void
		do
			buffer := buf
		end

feature -- Access

	buffer: STRING

feature -- Output

	output_string (a_str: detachable STRING_GENERAL)
			-- Output Unicode string
		do
			if a_str /= Void then
				to_implement ("Convert into UTF-8 or console encoding before output")
				buffer.append_string_general (a_str)
			end
		end

	output_integer (i: INTEGER)
		do
			buffer.append_integer (i)
		end

	output_new_line
		do
			buffer.append_character ('%N')
		end

end
