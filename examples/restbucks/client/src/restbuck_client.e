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
			s: READABLE_STRING_8
			j: JSON_PARSER
			id: detachable STRING
		do
			create h.make
			sess := h.new_session ("http://127.0.0.1")
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

			if attached sess.post ("/order", Void, s) as r then
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

			if id /= Void and then attached sess.get ("/order/" + id, Void) as r then
				print (r.body)
				io.put_new_line
			end
		end

feature -- Status

feature -- Access

feature -- Change

feature {NONE} -- Implementation

invariant
--	invariant_clause: True

end
