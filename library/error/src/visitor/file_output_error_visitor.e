note
	description: "File error output visitor"
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_OUTPUT_ERROR_VISITOR

inherit
	OUTPUT_ERROR_VISITOR
		redefine
			output_integer,
			output_new_line
		end

create
	make

feature -- Initialization

	make (f: like file)
		require
			f_open_write: f /= Void and then f.is_open_write
		do
			file := f
		end

feature -- Access

	file: FILE

feature -- Output

	output_string (a_str: detachable STRING_GENERAL)
			-- Output Unicode string
		do
			if a_str /= Void then
				to_implement ("Convert into UTF-8 or console encoding before output")
				file.put_string (a_str.as_string_8)
			end
		end

	output_integer (i: INTEGER)
		do
			file.put_integer (i)
		end

	output_new_line
		do
			file.put_new_line
		end

end
