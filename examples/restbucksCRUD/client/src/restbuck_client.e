note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	RESTBUCK_CLIENT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		local
			h: LIBCURL_HTTP_CLIENT
			sess: HTTP_CLIENT_SESSION
		do
			create h.make
			sess := h.new_session ("http://127.0.0.1:8080")
			-- Create Order
			create_order (sess)

--			if id /= Void and then attached sess.get ("/order/" + id, Void) as r then
--				print (r.body)
--				io.put_new_line
--			end
		end


	create_order (sess: HTTP_CLIENT_SESSION)
		local
			s: READABLE_STRING_8
			j: JSON_PARSER
			id: detachable STRING
			context : HTTP_CLIENT_REQUEST_CONTEXT
		do
			s := "[
			  	      {
						"location":"takeAway",
						"items":[
						        {
						        "name":"Late",
						        "option":"skim",
						        "size":"Small",
						        "quantity":1
						        }
						    ]
						}
				]"

			create context.make
			context.headers.put ("application/json", "Content-Type")
			if attached sess.post ("/order", context, s) as r then
				print (r.raw_header)
				io.put_new_line
				if attached r.body as m then
					create j.make_parser (m)
					if j.is_parsed and attached j.parse_object as j_o then
						if attached {JSON_STRING} j_o.item ("id") as l_id then
							id := l_id.item
						end
						print (m)
						io.put_new_line
					end
				end
			end

		end


feature {NONE} -- Implementation

invariant
--	invariant_clause: True

end
