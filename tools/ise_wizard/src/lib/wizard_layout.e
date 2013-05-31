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

	make (d: READABLE_STRING_GENERAL; cb: READABLE_STRING_GENERAL)
		do
			create wizard_directory_name.make_from_string (d)
			create callback_file_name.make_from_string (cb)
		end

feature -- Access

	wizard_directory_name: PATH

	callback_file_name: PATH

	resource (a_name: READABLE_STRING_GENERAL): STRING_32
		do
			Result := wizard_directory_name.extended ("resources").extended (a_name).name
		end

	pixmap_png_filename (a_name: READABLE_STRING_GENERAL): STRING_32
		do
			Result := wizard_directory_name.extended ("pixmaps").extended (a_name).appended_with_extension ("png").name
		end

invariant
end
