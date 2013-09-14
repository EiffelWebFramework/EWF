note
	description: "Summary description for {GOOGLE_AUTOCOMPLETION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOOGLE_AUTOCOMPLETION

inherit

	WSF_AUTOCOMPLETION

create
	make

feature {NONE} -- Initialization

	make ()
		do
			template := "{{=value}}";
		end

feature -- Implementation

	autocompletion (input: STRING): JSON_ARRAY
		local
			o: JSON_OBJECT
			l_result: INTEGER
			l_curl_string: CURL_STRING
			json_parser: JSON_PARSER
			query_str: STRING
		do
			query_str := input
			query_str.replace_substring_all (" ", "+")
			curl_handle := curl_easy.init
			create Result.make_array
			if curl_handle /= default_pointer then
				create l_curl_string.make_empty
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url, "http://suggestqueries.google.com/complete/search?client=firefox&q=" + query_str)
				curl_easy.set_write_function (curl_handle)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string.object_id)
				l_result := curl_easy.perform (curl_handle)

					-- Always cleanup
				curl_easy.cleanup (curl_handle)
				create json_parser.make_parser (l_curl_string.out)
				if attached {JSON_ARRAY} json_parser.parse_json as data and then attached {JSON_ARRAY} data.i_th (2) as list then
					across
						1 |..| list.count as c
					loop
						if attached {JSON_STRING} list.i_th (c.item) as row then
							create o.make
							o.put (create {JSON_STRING}.make_json (row.unescaped_string_32), "value")
							Result.add (o)
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	curl_easy: CURL_EASY_EXTERNALS
		once
			create Result
		end

	curl_handle: POINTER;
	-- cURL handle

end
