note
	description: "Summary description for {GOOGLE_NEWS_DATASOURCE}."
	date: "$Date$"
	revision: "$Revision$"

class
	GOOGLE_NEWS_DATASOURCE

inherit

	WSF_PAGABLE_DATASOURCE [GOOGLE_NEWS]
		redefine
			state,
			set_state
		end

create
	make_news


feature {NONE} -- Initialization

	make_news
		do
			page := 1
			page_size := 8
			query := "eiffel"
		end

feature -- States

	state: WSF_JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			Result := Precursor
			Result.put_string (query, "query")
		end

	set_state (new_state: JSON_OBJECT)
		do
			Precursor (new_state)
			if attached {JSON_STRING} new_state.item ("query") as new_query then
				query := new_query.unescaped_string_32
			end
		end

feature -- Access

	data: ITERABLE [GOOGLE_NEWS]
		local
			list: detachable ARRAYED_LIST [GOOGLE_NEWS]
			l_json: detachable READABLE_STRING_8
			json_parser: JSON_PARSER
			query_str: STRING_32
			cl: LIBCURL_HTTP_CLIENT
			sess: HTTP_CLIENT_SESSION
			ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
			row_count := 0
			query_str := query
			query_str.replace_substring_all ({STRING_32} " ", {STRING_32} "+")
			create cl.make
			sess := cl.new_session ("https://ajax.googleapis.com/ajax/services/search")
			sess.set_is_insecure (True)
			if sess.is_available then
				create ctx.make
				ctx.add_query_parameter ("q", query_str)
				if attached {HTTP_CLIENT_RESPONSE} sess.get ("/news?v=1.0&rsz=" + page_size.out + "&start=" + (page_size * (page - 1)).out, ctx) as l_response then
					if not l_response.error_occurred then
						l_json := l_response.body
					end
				end
			end
			if l_json /= Void and then not l_json.is_empty then
				create json_parser.make_parser (l_json)
				if attached {JSON_OBJECT} json_parser.parse_json as sp then
					if
						attached {JSON_OBJECT} sp.item ("responseData") as responsedata and then
						attached {JSON_ARRAY} responsedata.item ("results") as results
					then
						row_count := 0
						if
							attached {JSON_OBJECT} responsedata.item ("cursor") as cursor and then
							attached {JSON_STRING} cursor.item ("estimatedResultCount") as count
						then
							row_count := count.item.to_integer.min (64)
						end
						create list.make (results.count)
						across
							1 |..| results.count as c
						loop
							if attached {JSON_OBJECT} results.i_th (c.item) as j then
								list.extend (create {GOOGLE_NEWS}.make_from_json (j))
							end
						end
					end
				end
			end
			if list = Void then
				create list.make (0)
			end
			Result := list
		end

feature

	set_query (q: STRING_32)
		do
			query := q
		end

	query: STRING_32

end
