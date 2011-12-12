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
			resp : HTTP_CLIENT_RESPONSE
			l_location : detachable READABLE_STRING_8
			body : STRING
		do
			create h.make
			sess := h.new_session ("http://127.0.0.1:8080")
			-- Create Order
			print ("%N Create Order %N")
			resp := create_order (sess)

			-- Read the Order
			print ("%N Read Order %N")
			l_location := resp.headers.at ("Location")
			resp := read_order (sess, l_location)


			-- Update the Order

			if attached resp.body as l_body then
				body := l_body.as_string_8
				body.replace_substring_all ("takeAway", "in Shop")
				print ("%N Update Order %N")
				resp := update_order (sess, l_location, body)
			end
		end

	update_order ( sess: HTTP_CLIENT_SESSION; uri : detachable READABLE_STRING_8; a_body : STRING) : HTTP_CLIENT_RESPONSE
		local
			l_headers: HASH_TABLE [READABLE_STRING_8,READABLE_STRING_8]
		do
			create Result.make
			if attached uri as l_uri then
				sess.set_base_url (l_uri)
				Result := sess.put ("", Void, a_body )
				if attached Result as r then
					-- Show headers
					l_headers := r.headers
					from
						l_headers.start
					until
						l_headers.after
					loop
						print (l_headers.key_for_iteration)
						print (":")
						print (l_headers.item_for_iteration)
						l_headers.forth
						io.put_new_line
					end

					-- Show body
					print (r.body)
					io.put_new_line
				end
			end
		end


	read_order ( sess: HTTP_CLIENT_SESSION; uri : detachable READABLE_STRING_8) : HTTP_CLIENT_RESPONSE
		local
			l_headers: HASH_TABLE [READABLE_STRING_8,READABLE_STRING_8]
		do
			create Result.make
			if attached uri as l_uri then
				sess.set_base_url (l_uri)
				Result := sess.get ("", Void)
				if attached Result as r then
					-- Show headers
					l_headers := r.headers
					from
						l_headers.start
					until
						l_headers.after
					loop
						print (l_headers.key_for_iteration)
						print (":")
						print (l_headers.item_for_iteration)
						l_headers.forth
						io.put_new_line
					end

					-- Show body
					print (r.body)
					io.put_new_line
				end
			end
		end



	create_order (sess: HTTP_CLIENT_SESSION) : HTTP_CLIENT_RESPONSE
		local
			s: READABLE_STRING_8
			j: JSON_PARSER
			id: detachable STRING
			context : HTTP_CLIENT_REQUEST_CONTEXT
			l_headers: HASH_TABLE [READABLE_STRING_8,READABLE_STRING_8]
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
			Result := sess.post ("/order", context, s)
			if attached Result as r then
				-- Show the Headers
				l_headers := r.headers
				from
					l_headers.start
				until
					l_headers.after
				loop
					print (l_headers.key_for_iteration)
					print (":")
					print (l_headers.item_for_iteration)
					l_headers.forth
					io.put_new_line
				end


				-- Show the Response body
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
