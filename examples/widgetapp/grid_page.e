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
			container: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create container.make_multi_control ("container")
			container.add_class ("container")
			container.add_control (create {WSF_STATELESS_HTML_CONTROL}.make_html("h1","Grid Demo"))
			create datasource.make_news
			create search_query.make_autocomplete ("query", create {GOOGLE_AUTOCOMPLETION}.make)
			search_query.add_class ("form-control")
			search_query.set_change_event (agent change_query)
			container.add_control (search_query)
			container.add_control (create {WSF_STATELESS_HTML_CONTROL}.make_html("h2","Results"))
			create grid.make_grid ("mygrid", <<create {WSF_GRID_COLUMN}.make_column ("Title", "title"), create {WSF_GRID_COLUMN}.make_column ("Content", "content"), create {WSF_GRID_IMAGE_COLUMN}.make_image_column ("Image", "image")>>, datasource)
			container.add_control (grid)
			control := container
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
