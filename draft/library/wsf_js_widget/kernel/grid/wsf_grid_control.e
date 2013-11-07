note
	description: "Summary description for {WSF_GRID_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_GRID_CONTROL [G -> WSF_ENTITY]

inherit

	WSF_REPEATER_CONTROL [G]
		rename
			make as make_repeater
		redefine
			render
		end

create
	make

feature {NONE} -- Initialization

	make (a_columns: ITERABLE [WSF_GRID_COLUMN]; a_datasource: WSF_DATASOURCE [G])
		do
			make_repeater (a_datasource)
			columns := a_columns
		end

feature -- Render

	render_item (item: G): STRING
			-- Render table row
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
			-- Render table header
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
			-- Render entre table and subcontrols
		local
			table: STRING
		do
			table := render_tag_with_tagname ("table", render_header + render_tag_with_tagname ("tbody", render_body, "", ""), "", "table table-striped")
			Result := ""
			across
				controls as c
			loop
				Result.append (c.item.render)
			end
			Result := render_tag (table + Result, "")
		end

feature -- Properties

	columns: ITERABLE [WSF_GRID_COLUMN]

end
