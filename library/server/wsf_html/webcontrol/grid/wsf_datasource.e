note
	description: "Summary description for {WSF_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_DATASOURCE [G -> WSF_ENTITY]

feature --State

	state: JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			create Result.make
			Result.put (create {JSON_NUMBER}.make_integer(page), create {JSON_STRING}.make_json("page"))
			Result.put (create {JSON_NUMBER}.make_integer(page_size), create {JSON_STRING}.make_json("page_size"))
			if attached sort_column as a_sort_column then
				Result.put (create {JSON_STRING}.make_json(a_sort_column), create {JSON_STRING}.make_json("sort_column"))
			else
				Result.put (create {JSON_NULL}, create {JSON_STRING}.make_json("sort_column"))
			end
			Result.put (create {JSON_BOOLEAN}.make_boolean(sort_direction), create {JSON_STRING}.make_json("sort_direction"))
		end

	set_state (new_state: JSON_OBJECT)
		do
			if attached {JSON_NUMBER} new_state.item (create {JSON_STRING}.make_json ("page")) as new_page then
				page := new_page.integer_type
			end
			if attached {JSON_NUMBER} new_state.item (create {JSON_STRING}.make_json ("page_size")) as new_page_size then
				page_size := new_page_size.integer_type
			end
			if attached {JSON_STRING} new_state.item (create {JSON_STRING}.make_json ("sort_column")) as new_sort_column then
				sort_column := new_sort_column.unescaped_string_32
			elseif attached {JSON_NULL} new_state.item (create {JSON_STRING}.make_json ("sort_column")) as new_sort_column then
				sort_column := VOID
			end
			if attached {JSON_BOOLEAN} new_state.item (create {JSON_STRING}.make_json ("sort_direction")) as new_sort_direction then
				sort_direction := new_sort_direction.item
			end
		end
feature

	set_page (a_page: like page)
		do
			page := a_page
		end

	set_page_size (a_page_size: like page_size)
		do
			page_size := a_page_size
		end

	set_sort_column (a_sort_column: like sort_column)
		do
			sort_column := a_sort_column
		end

	set_sort_direction (a_sort_direction: like sort_direction)
		do
			sort_direction := a_sort_direction
		end

	page: INTEGER

	page_size: INTEGER

	sort_column: detachable STRING

	sort_direction: BOOLEAN

	data: ITERABLE [G]
	deferred
	end
end
