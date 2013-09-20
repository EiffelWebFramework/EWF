note
	description: "Summary description for {WSF_PAGABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PAGABLE_DATASOURCE [G -> WSF_ENTITY]

inherit

	WSF_DATASOURCE [G]
		redefine
			state,
			set_state,
			update
		end

feature -- Update event

	set_on_update_page_agent (f: PROCEDURE [ANY, TUPLE []])
		do
			on_update_page_agent := f
		end

	update
		do
			if attached on_update_agent as a then
				a.call (Void)
			end
			if attached on_update_page_agent as a then
				a.call (Void)
			end
		end

	on_update_page_agent: detachable PROCEDURE [ANY, TUPLE []]

feature --States

	state: JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			Result := Precursor
			Result.put (create {JSON_NUMBER}.make_integer (page), "page")
			Result.put (create {JSON_NUMBER}.make_integer (page_size), "page_size")
			Result.put (create {JSON_NUMBER}.make_integer (row_count), "row_count")
		end

	set_state (new_state: JSON_OBJECT)
		do
			Precursor (new_state)
			if attached {JSON_NUMBER} new_state.item ("page") as new_page then
				page := new_page.item.to_integer
			end
			if attached {JSON_NUMBER} new_state.item ("page_size") as new_page_size then
				page_size := new_page_size.item.to_integer
			end
			if attached {JSON_NUMBER} new_state.item ("row_count") as new_row_count then
				row_count := new_row_count.item.to_integer
			end
		end

feature

	set_page (p: INTEGER)
		do
			page := p.min (page_count).max (1)
		end

	row_count: INTEGER

	page_count: INTEGER
		do
			Result := (row_count / page_size).ceiling
		end

end
