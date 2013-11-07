note
	description: "Summary description for {GRID_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature

	initialize_controls
		do
			Precursor
			control.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", "Grid Demo"))
			create datasource.make_news
			create search_query.make (create {GOOGLE_AUTOCOMPLETION}.make)
			search_query.add_class ("form-control")
			search_query.set_change_event (agent change_query)
			control.add_control (search_query)
			control.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h2", "", "Results"))
			create grid.make (<<create {WSF_GRID_COLUMN}.make ("Title", "title"), create {WSF_GRID_COLUMN}.make ("Content", "content")>>, datasource)
			control.add_control (grid)
			navbar.set_active (2)
		end

	change_query
		do
			datasource.set_query (search_query.value)
			datasource.set_page (1)
			datasource.update
		end

	process
		do
		end

	grid: WSF_GRID_CONTROL [GOOGLE_NEWS]

	search_query: WSF_AUTOCOMPLETE_CONTROL

	datasource: GOOGLE_NEWS_DATASOURCE

end
