note
	description: "Summary description for {WSF_GRID_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_GRID_CONTROL [G -> WSF_ENTITY]

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		redefine
			set_state,
			state,
			handle_callback,
			render
		end

create
	make_grid

feature {NONE}

	make_grid (n: STRING; a_columns: ITERABLE [WSF_GRID_COLUMN]; a_datasource: WSF_DATASOURCE [G])
		do
			make_multi_control (n)
			columns := a_columns
			datasource := a_datasource
			datasource.set_on_update_agent (agent update)
			if attached {WSF_PAGABLE_DATASOURCE [G]} a_datasource as ds then
				create pagination_control.make_paging (n + "_paging", ds)
				add_control (pagination_control)
			end
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	update
		do
			state_changes.replace (create {JSON_STRING}.make_json (render_body), create {JSON_STRING}.make_json ("_body"))
			state_changes.replace (datasource.state, create {JSON_STRING}.make_json ("datasource"))
		end

	set_state (new_state: JSON_OBJECT)
			-- Restore html from json
		do
			if attached {JSON_OBJECT} new_state.item (create {JSON_STRING}.make_json ("datasource")) as datasource_state then
				datasource.set_state (datasource_state)
			end
		end

	state: JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			create Result.make
			Result.put (datasource.state, create {JSON_STRING}.make_json ("datasource"))
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
		do
			Precursor (cname, event, event_parameter)
		end

feature -- Implementation

	render_header: STRING
		do
			Result := ""
			across
				columns as c
			loop
				Result.append (render_tag_with_tagname ("th", c.item.header, "", ""))
			end
			Result := render_tag_with_tagname ("thead", render_tag_with_tagname ("tr", Result, "", ""), "", "")
		end

	render_body: STRING
		local
			row: STRING
		do
			Result := ""
			across
				datasource.data as entity
			loop
				row := ""
				across
					columns as c
				loop
					row.append (render_tag_with_tagname ("td", c.item.render_column (entity.item), "", ""))
				end
				Result.append (render_tag_with_tagname ("tr", row, "", ""))
			end
			Result := render_tag_with_tagname ("tbody", Result, "", "")
		end

	render: STRING
		local
			table: STRING
		do
			table := render_tag_with_tagname ("table", render_header + render_body, "", "table table-striped")
			Result := ""
			across
				controls as c
			loop
				Result := c.item.render + Result
			end
			Result := render_tag (table + Result, "")
		end

feature

	columns: ITERABLE [WSF_GRID_COLUMN]

	datasource: WSF_DATASOURCE [G]

	pagination_control: detachable WSF_PAGINATION_CONTROL [G]

end
