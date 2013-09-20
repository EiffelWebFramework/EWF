note
	description: "Summary description for {WSF_GRID_IMAGE_COLUMN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_GRID_IMAGE_COLUMN

inherit

	WSF_GRID_COLUMN
		rename
			make as make_column
		redefine
			render_column
		end

create
	make

feature {NONE}

	make (a_header, a_field: STRING)
		do
			make_column (a_header, a_field)
		end

feature

	render_column (e: WSF_ENTITY): STRING
		do
			if attached e.item (field_name) as data then
				Result := "<img src=%"" + data.out + "%" />"
			else
				Result := "[VOID]"
			end
		end

end
