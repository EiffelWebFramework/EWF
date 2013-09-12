note
	description: "Summary description for {GRID_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID_PAGE

inherit

	WSF_PAGE_CONTROL

create
	make

feature

	initialize_controls
		local
			ds: DEMO_DATASOURCE
		do
			create ds.make_demo
			create grid.make_grid ("mygrid", <<create {WSF_GRID_COLUMN}.make_column ("#", "id"), create {WSF_GRID_COLUMN}.make_column ("Name", "name"), create {WSF_GRID_COLUMN}.make_column ("Description", "description")>>, ds)
			control := grid
		end

	process
		do
		end

	grid: WSF_GRID_CONTROL [DEMO_DATA]

end
