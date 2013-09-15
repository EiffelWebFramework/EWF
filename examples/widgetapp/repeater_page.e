note
	description: "Summary description for {REPEATER_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REPEATER_PAGE

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
			container.add_control (create {WSF_BASIC_CONTROL}.make_with_body("h1","","Repeater Demo"))
			create datasource.make_news
			create search_query.make_autocomplete ("query", create {GOOGLE_AUTOCOMPLETION}.make)
			search_query.add_class ("form-control")
			search_query.set_change_event (agent change_query)
			container.add_control (search_query)
			container.add_control (create {WSF_BASIC_CONTROL}.make_with_body("h2","","Results"))
			create repeater.make_repeater ("myrepeater", datasource)
			container.add_control (repeater)
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

