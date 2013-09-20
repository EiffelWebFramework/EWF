note
	description: "Summary description for {WSF_GRID_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_GRID_CONTROL [G -> WSF_ENTITY]

inherit

	WSF_REPEATER_CONTROL [G]
		redefine
			render
		end

create
	make_grid

feature {NONE}

	make_grid (n: STRING; a_columns: ITERABLE [WSF_GRID_COLUMN]; a_datasource: WSF_DATASOURCE [G])
		do
			make_repeater (n, a_datasource)
			columns := a_columns
		end

feature -- Implementation

	render_item (item: G): STRING
		do
			Result := ""
			across
				columns as c
			loop
				Result.append (render_tag_with_tagname ("td", c.item.render_column (item), "", ""))
			end
			Result := render_tag_with_tagname ("tr", Result, "", "")
		end

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

	render: STRING
		local
			table: STRING
		do
			table := render_tag_with_tagname ("table", render_header + render_tag_with_tagname ("tbody", render_body, "", ""), "", "table table-striped")
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

end
