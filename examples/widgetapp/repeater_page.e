note
	description: "Summary description for {REPEATER_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REPEATER_PAGE
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
			container.add_control (create {WSF_STATELESS_HTML_CONTROL}.make_html("h1","Repeater Demo"))
			create datasource.make_news
			create search_query.make_autocomplete ("query", create {GOOGLE_AUTOCOMPLETION}.make)
			search_query.add_class ("form-control")
			search_query.set_change_event (agent change_query)
			container.add_control (search_query)
			container.add_control (create {WSF_STATELESS_HTML_CONTROL}.make_html("h2","Results"))
			create repeater.make_repeater ("myrepeater", datasource)
			container.add_control (repeater)
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

	repeater: GOOGLE_NEWS_REPEATER

	search_query: WSF_AUTOCOMPLETE_CONTROL

	datasource: GOOGLE_NEWS_DATASOURCE

end

