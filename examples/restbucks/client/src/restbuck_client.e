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
				print (r.body)
			end

			if attached sess.get ("/order/1", Void) as r then
				print (r.body)
			end
		end

feature -- Status

feature -- Access

feature -- Change

feature {NONE} -- Implementation

invariant
--	invariant_clause: True

end
