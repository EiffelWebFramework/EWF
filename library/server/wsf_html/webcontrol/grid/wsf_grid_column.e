note
	description: "Summary description for {WSF_GRID_COLUMN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_GRID_COLUMN
create
	make_column
feature {NONE}

	make_column(a_header,a_field:STRING)
	do
		header:=a_header
		field_name:=a_field
		sorting_name:=a_field
	end
feature

	header: STRING

	sortable: BOOLEAN

	sorting_name: STRING

	field_name: STRING

	render_column (e: WSF_ENTITY): STRING
		do
			if attached e.get (field_name) as data then
				Result := data.out
			else
				Result := "[VOID]"
			end
		end

end
