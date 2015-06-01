note
	description: "Summary description for {GOOGLE_AUTOCOMPLETION}."
	date: "$Date$"
	revision: "$Revision$"

class
	GOOGLE_AUTOCOMPLETION

inherit

	WSF_AUTOCOMPLETION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			template := "{{=value}}";
		end

feature -- Implementation

	autocompletion (input: STRING_32): JSON_ARRAY
			-- Implementation
		local
			cl: LIBCURL_HTTP_CLIENT
			sess: HTTP_CLIENT_SESSION
			l_json: detachable READABLE_STRING_8
			o: JSON_OBJECT
			json_parser: JSON_PARSER
			query_str: STRING_32
			ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
			query_str := input
			query_str.replace_substring_all (" ", "+")
			create cl.make
			sess := cl.new_session ("http://google.com")
			create ctx.make
			ctx.add_query_parameter ("q", query_str)
			if attached sess.get ("/complete/search?client=chrome", ctx) as resp and then not resp.error_occurred then
				l_json := resp.body
			end
			create Result.make_empty
			if l_json /= Void and then not l_json.is_empty then
				create json_parser.make_with_string (l_json)
				json_parser.parse_content
				if
					json_parser.is_valid and then
					attached {JSON_ARRAY} json_parser.parsed_json_value as data and then
					data.valid_index (2) and then
					attached {JSON_ARRAY} data.i_th (2) as list
				then
					across
						1 |..| list.count as c
					loop
						if attached {JSON_STRING} list.i_th (c.item) as row then
							create o.make
							o.put (create {JSON_STRING}.make_from_escaped_json_string (row.item), "value")
							Result.add (o)
						end
					end
				end
			end
		end

end
