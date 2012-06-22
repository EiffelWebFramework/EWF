note
	description: "Summary description for {WIZARD_LAYOUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WIZARD_LAYOUT

create
	make

feature {NONE} -- Initialization

	make (d: like wizard_directory_name; cb: like callback_file_name)
		do
			wizard_directory_name := d
			callback_file_name := cb
		end

feature -- Access

	wizard_directory_name: READABLE_STRING_8

	resource (a_name: READABLE_STRING_8): STRING_8
		local
			fn: FILE_NAME
		do
			create fn.make_from_string (wizard_directory_name)
			fn.extend ("resources")
			fn.set_file_name (a_name)
			Result := fn.string
		end

	pixmap_png_filename (a_name: READABLE_STRING_8): STRING_8
		local
			fn: FILE_NAME
		do
			create fn.make_from_string (wizard_directory_name)
			fn.extend ("pixmaps")
			fn.set_file_name (a_name)
			fn.add_extension ("png")
			Result := fn.string
		end

	callback_file_name: READABLE_STRING_8

invariant
end
