note
	description: "Summary description for {WSF_GRID_COLUMN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_GRID_COLUMN

create
	make

feature {NONE} -- Initialization

	make (a_header, a_field: STRING_32)
		do
			header := a_header
			field_name := a_field
			sorting_name := a_field
		end

feature -- Render

	render_column (e: WSF_ENTITY): STRING_32
			-- Return the rendered column cell for a specific entity (row)
		do
			if attached e.item (field_name) as data then
					--| FIXME: .out may not be the best rendering for objects...
 				Result := data.out
			else
				Result := "[VOID]"
			end
		end

feature -- Access

	header: STRING_32

	sortable: BOOLEAN

	sorting_name: STRING_32

	field_name: STRING_32

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
