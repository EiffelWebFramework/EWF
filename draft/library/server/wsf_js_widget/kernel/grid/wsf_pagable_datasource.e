note
	description: "Summary description for {WSF_PAGABLE_DATASOURCE}."
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

feature -- Event handling

	set_on_update_page_agent (f: PROCEDURE)
			-- Set paging update listener
		do
			on_update_page_agent := f
		end

	update
			-- Trigger update listeners
		do
			Precursor
			if attached on_update_page_agent as a then
				a.call (Void)
			end
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	state: WSF_JSON_OBJECT
			-- Return state which contains the current page, page_size and row_count
		do
			Result := Precursor
			Result.put_integer (page, "page")
			Result.put_integer (page_size, "page_size")
			Result.put_integer (row_count, "row_count")
		end

	set_state (new_state: JSON_OBJECT)
			-- Restore page, page_size and row_count from json
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

feature -- Change

	set_page (p: INTEGER)
		do
			page := p.min (page_count).max (1)
		end

feature -- Properties

	page: INTEGER

	page_size: INTEGER

	row_count: INTEGER

	page_count: INTEGER
		do
			Result := (row_count / page_size).ceiling
		end

	on_update_page_agent: detachable PROCEDURE

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
