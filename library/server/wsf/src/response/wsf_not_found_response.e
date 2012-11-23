note
	description: "[
				This class is used to report a 404 Not found page
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NOT_FOUND_RESPONSE


inherit
	WSF_RESPONSE_MESSAGE

	SHARED_HTML_ENCODER

create
	make

feature {NONE} -- Initialization

	make (req: WSF_REQUEST)
		do
			request := req
			create header.make
			create suggested_locations.make (0)
		end

feature -- Header

	header: HTTP_HEADER
			-- Response' header

	request: WSF_REQUEST
			-- Associated request.

	suggested_locations: ARRAYED_LIST [TUPLE [location: READABLE_STRING_8; title: detachable READABLE_STRING_GENERAL]]
			-- Optional suggestions
			-- First is the default.

feature -- Element change

	add_suggested_location (a_loc: READABLE_STRING_8; a_title: detachable READABLE_STRING_GENERAL)
			-- Add `a_loc' to `suggested_locations'
		do
			suggested_locations.force ([a_loc, a_title])
		end

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
		local
			s: STRING
			l_title: detachable READABLE_STRING_GENERAL
			h: like header
		do
			h := header
			res.set_status_code ({HTTP_STATUS_CODE}.not_found)

			s := "<html><head>"
			s.append ("<title>")
			s.append (html_encoder.encoded_string (request.request_uri))
			s.append (" - 404 Not Found")
			s.append ("</title>%N")
			s.append ("[
					<style type="text/css">
					div#header {color: #fff; background-color: #000; padding: 20px; width: 100%; text-align: center; font-size: 2em; font-weight: bold;}
					div#message { margin: 40px; width: 100%; text-align: center; font-size: 1.5em; }
					div#suggestions { margin: auto; width: 60%;}
					div#suggestions ul { }
					div#footer {color: #999; background-color: #eee; padding: 10px; width: 100%; text-align: center; }
					div#logo { float: right; margin: 20px; width: 60px height: auto; font-size: 0.8em; text-align: center; }
					div#logo div.outter { padding: 6px; width: 60px; border: solid 3px #500; background-color: #b00;}
					div#logo div.outter div.inner1 { display: block; margin: 10px 15px;  width: 30px; height: 50px; color: #fff; background-color: #fff; border: solid 2px #900; }
					div#logo div.outter div.inner2 { margin: 10px 15px; width: 30px; height: 15px; color: #fff; background-color: #fff; border: solid 2px #900; }
					</style>
					</head>
					<body>
					<div id="header">404 Not Found</div>
					]")
			s.append ("<div id=%"logo%">")
			s.append ("<div class=%"outter%"> ")
			s.append ("<div class=%"inner1%"></div>")
			s.append ("<div class=%"inner2%"></div>")
			s.append ("</div>")
			s.append ("404 Not Found</div>")
			s.append ("<div id=%"message%">404 Not Found: <code>" + html_encoder.encoded_string (request.request_uri) + "</code></div>")
			if attached suggested_locations as lst and then not lst.is_empty then
				s.append ("<div id=%"suggestions%"><strong>Perhaps your are looking for:</strong><ul>")
				from
					lst.start
				until
					lst.after
				loop
					s.append ("<li>")
					l_title := lst.item.title
					if l_title = Void then
						l_title := lst.item.location
					end
					s.append ("<a href=%"" + lst.item.location + "%">" + html_encoder.encoded_string (l_title.to_string_32) + "</a>")
					s.append ("</li>%N")

					lst.forth
				end
				s.append ("</ul></div>%N")
			end
			s.append ("<div id=%"footer%"></div>")
			s.append ("</body>%N")
			s.append ("</html>%N")

			h.put_content_length (s.count)
			h.put_content_type_text_html
			res.put_header_text (h.string)
			res.put_string (s)
			res.flush
		end

note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
