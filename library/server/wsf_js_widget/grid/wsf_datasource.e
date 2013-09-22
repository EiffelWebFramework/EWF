note
	description: "Summary description for {WSF_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_DATASOURCE [G -> WSF_ENTITY]

feature --Event handling

	set_on_update_agent (f: PROCEDURE [ANY, TUPLE])
			--Set update listener
		do
			on_update_agent := f
		end

	update
			--Trigger update listener
		do
			if attached on_update_agent as a then
				a.call (Void)
			end
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	state: JSON_OBJECT
			-- Return state which contains the current sort_column and sort_direction
		do
			create Result.make
			if attached sort_column as a_sort_column then
				Result.put (create {JSON_STRING}.make_json (a_sort_column), "sort_column")
			else
				Result.put (create {JSON_NULL}, "sort_column")
			end
			Result.put (create {JSON_BOOLEAN}.make_boolean (sort_direction), "sort_direction")
		end

	set_state (new_state: JSON_OBJECT)
			-- Restore sort_column and sort_direction from json
		do
			if attached {JSON_STRING} new_state.item ("sort_column") as new_sort_column then
				sort_column := new_sort_column.unescaped_string_32 -- Implicit Conversion !
			elseif attached {JSON_NULL} new_state.item ("sort_column") as new_sort_column then
				sort_column := Void
			end
			if attached {JSON_BOOLEAN} new_state.item ("sort_direction") as new_sort_direction then
				sort_direction := new_sort_direction.item
			end
		end

feature -- Change

	set_sort_column (a_sort_column: like sort_column)
			-- Set the column by which the data should be sorted
		do
			sort_column := a_sort_column
		end

	set_sort_direction (a_sort_direction: like sort_direction)
			-- Set the sorting direction
		do
			sort_direction := a_sort_direction
		end

feature -- Properties

	sort_column: detachable STRING

	sort_direction: BOOLEAN

	data: ITERABLE [G]
		deferred
		end

	on_update_agent: detachable PROCEDURE [ANY, TUPLE]

end
