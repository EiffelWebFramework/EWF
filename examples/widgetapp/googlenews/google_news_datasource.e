note
	description: "Summary description for {GOOGLE_NEWS_DATASOURCE}."
	author: ""
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

feature --States

	state: JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			Result := Precursor
			Result.put (create {JSON_STRING}.make_json (query), create {JSON_STRING}.make_json ("query"))
		end

	set_state (new_state: JSON_OBJECT)
		do
			Precursor (new_state)
			if attached {JSON_STRING} new_state.item (create {JSON_STRING}.make_json ("query")) as new_query then
				query := new_query.item
			end
		end

feature

	make_news
		do
			page := 1
			page_size := 8
			query := "eiffel"
		end

	data: ITERABLE [GOOGLE_NEWS]
		local
			list: LINKED_LIST [GOOGLE_NEWS]
			l_result: INTEGER
			l_curl_string: CURL_STRING
			json_parser: JSON_PARSER
			query_str: STRING
		do
			curl_handle := curl_easy.init
			create list.make
			row_count := 0
			if curl_handle /= default_pointer then
				create l_curl_string.make_empty
				query_str := query.out
				query_str.replace_substring_all (" ", "+")
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url, "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=" + query_str + "&rsz=" + page_size.out + "&start=" + (page_size * (page - 1)).out)
				curl_easy.set_write_function (curl_handle)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string.object_id)
				l_result := curl_easy.perform (curl_handle)

					-- Always cleanup
				curl_easy.cleanup (curl_handle)
				create json_parser.make_parser (l_curl_string.out)
				if attached {JSON_OBJECT} json_parser.parse_json as sp then
					if attached {JSON_OBJECT} sp.item (create {JSON_STRING}.make_json ("responseData")) as responsedata and then attached {JSON_ARRAY} responsedata.item (create {JSON_STRING}.make_json ("results")) as results then
						if attached {JSON_OBJECT} responsedata.item (create {JSON_STRING}.make_json ("cursor")) as cursor and then attached {JSON_STRING} cursor.item (create {JSON_STRING}.make_json ("estimatedResultCount")) as count then
							row_count := count.item.to_integer.min (64)
						end
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
			Result := list
		end

feature

	set_query (q: STRING)
		do
			query := q
		end

	query: STRING

feature {NONE} -- Implementation

	curl_easy: CURL_EASY_EXTERNALS
		once
			create Result
		end

	curl_handle: POINTER;
	-- cURL handle

end
