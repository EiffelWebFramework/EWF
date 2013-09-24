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

feature {NONE} -- Initialization

	make (a_header, a_field: STRING)
		do
			make_column (a_header, a_field)
		end

feature -- Render

	render_column (e: WSF_ENTITY): STRING
			-- Return the rendered column image cell for a specific entity (row)
		do
			if attached e.item (field_name) as data then
				Result := "<img src=%"" + data.out + "%" />"
			else
				Result := "[VOID]"
			end
		end

end
