note
	description: "[
				This class is used to report a 405 Method not allowed response
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_METHOD_NOT_ALLOWED_RESPONSE

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
			create suggested_methods
			create suggested_items.make (0)
		end

feature -- Header

	header: HTTP_HEADER
			-- Response' header

	request: WSF_REQUEST
			-- Associated request.

	suggested_methods: WSF_REQUEST_METHODS
			-- Optional suggestions
			-- First is the default.

	suggested_items: ARRAYED_LIST [TUPLE [location: detachable READABLE_STRING_8; text: detachable READABLE_STRING_GENERAL; description: detachable READABLE_STRING_GENERAL]]
			-- Optional suggestions
			-- First is the default.

	body: detachable READABLE_STRING_8
			-- Optional body
			-- Displayed as extra content

feature -- Element change

	set_suggested_methods (m: like suggested_methods)
			-- Set `suggested_methods' to `m'
		do
			suggested_methods := m
		end

	add_suggested_location (a_loc: READABLE_STRING_8; a_title: detachable READABLE_STRING_GENERAL; a_description: detachable READABLE_STRING_GENERAL)
			-- Add `a_loc' to `suggested_items'
		do
			suggested_items.force ([a_loc, a_title, a_description])
		end

	add_suggested_text (a_text: READABLE_STRING_GENERAL; a_description: detachable READABLE_STRING_GENERAL)
			-- Add `a_text' to `suggested_items'
		do
			suggested_items.force ([Void, a_text, a_description])
		end

	set_body (b: like body)
			-- Set `body' to `b'
		do
			body := b
		end

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
		local
			s: STRING
			l_text: detachable READABLE_STRING_GENERAL
			l_loc: detachable READABLE_STRING_8
			h: like header
		do
			h := header
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)

			if attached suggested_methods as lst and then not lst.is_empty then
				h.put_allow (lst)
			end

			s := "Not allowed"

			if request.is_content_type_accepted ({HTTP_MIME_TYPES}.text_html) then
				s := "<html lang=%"en%"><head>"
				s.append ("<title>")
				s.append (html_encoder.encoded_string (request.request_uri))
				s.append ("Error 405 (Method Not Allowed)!!")
				s.append ("</title>%N")
				s.append (
					"[
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
						<div id="header">Error 405 (Method Not Allowed)!!</div>
					]")
				s.append ("<div id=%"logo%">")
				s.append ("<div class=%"outter%"> ")
				s.append ("<div class=%"inner1%"></div>")
				s.append ("<div class=%"inner2%"></div>")
				s.append ("</div>")
				s.append ("Error 405 (Method Not Allowed)</div>")
				s.append ("<div id=%"message%">Error 405 (Method Not Allowed): the request method <code>")
				s.append (request.request_method)
				s.append ("</code> is inappropriate for the URL for <code>" + html_encoder.encoded_string (request.request_uri) + "</code>.</div>")
				if attached suggested_methods as lst and then not lst.is_empty then
					s.append ("<div id=%"suggestions%"><strong>Allowed methods:</strong>")
					across
						lst as c
					loop
						s.append (" ")
						s.append (c.item)
					end
					s.append ("%N")
				end

				if attached suggested_items as lst and then not lst.is_empty then
					s.append ("<div id=%"suggestions%"><strong>Perhaps your are looking for:</strong><ul>")
					from
						lst.start
					until
						lst.after
					loop
						l_text := lst.item.text
						l_loc := lst.item.location
						if l_loc /= Void then
							if l_text = Void then
								l_text := l_loc
							end
							s.append ("<li>")
							s.append ("<a href=%"" + l_loc + "%">" + html_encoder.encoded_string (l_text.to_string_32) + "</a>")
						elseif l_text /= Void then

							s.append ("<li>")
							s.append (html_encoder.encoded_string (l_text.to_string_32))
							s.append ("</li>%N")
						end
						if (l_loc /= Void or l_text /= Void) then
							if attached lst.item.description as l_desc then
								s.append ("<br/> - ")
								s.append (html_encoder.encoded_string (l_desc.to_string_32))
								s.append ("%N")
							end
							s.append ("</li>%N")
						end

						lst.forth
					end
					s.append ("</ul></div>%N")
				end
				if attached body as b then
					s.append ("<div>")
					s.append (b)
					s.append ("</div>%N")
				end


				s.append ("<div id=%"footer%"></div>")
				s.append ("</body>%N")
				s.append ("</html>%N")

				h.put_content_type_text_html
			else
				s := "Error 405 (Method Not Allowed): the request method "
				s.append (request.request_method)
				s.append (" is inappropriate for the URL for '" + html_encoder.encoded_string (request.request_uri) + "'.%N")
				if attached suggested_methods as lst and then not lst.is_empty then
					s.append ("Allowed methods:")
					across
						lst as c
					loop
						s.append (" ")
						s.append (c.item)
					end
					s.append ("%N")
				end
				if attached suggested_items as lst and then not lst.is_empty then
					s.append ("%NPerhaps your are looking for:%N")
					from
						lst.start
					until
						lst.after
					loop
						l_text := lst.item.text
						l_loc := lst.item.location
						if l_loc /= Void then
							s.append (" - ")
							if l_text = Void then
								s.append (l_loc)
							else
								s.append (" : ")
								s.append (l_text.to_string_8)
							end
						elseif l_text /= Void then
							s.append (" - ")
							s.append (l_text.to_string_8)
						end
						if (l_loc /= Void or l_text /= Void) then
							s.append ("%N")
							if attached lst.item.description as l_desc then
								s.append ("   ")
								s.append (l_desc.to_string_8)
								s.append ("%N")
							end
						end
						lst.forth
					end
				end
				if attached body as b then
					s.append ("%N")
					s.append (b)
					s.append ("%N")
				end
				h.put_content_type_text_plain
			end

			h.put_content_length (s.count)
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
