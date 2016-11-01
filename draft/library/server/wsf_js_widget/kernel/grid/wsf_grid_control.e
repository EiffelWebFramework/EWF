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
			columns := a_columns
			make_repeater (a_datasource)
		end

feature -- Render

	render_item (item: G): STRING_32
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

	render_header: STRING_32
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

	render: STRING_32
			-- Render entre table and subcontrols
		local
			table: STRING_32
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

;note
	copyright: "2011-2016, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
