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
		end

feature -- Header

	header: HTTP_HEADER
			-- Response' header

	request: WSF_REQUEST
			-- Associated request.

	suggested_methods: WSF_ROUTER_METHODS
			-- Optional suggestions
			-- First is the default.

feature -- Element change

	set_suggested_methods (m: like suggested_methods)
			-- Set `suggested_methods' to `m'
		do
			suggested_methods := m
		end

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
		local
			s: STRING
			l_title: detachable READABLE_STRING_GENERAL
			h: like header
		do
			h := header
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			s := "Not allowed"

			if request.is_content_type_accepted ({HTTP_MIME_TYPES}.text_html) then
				s := "<html><head>"
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
