note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HELLO_ROUTED_WORLD_EXECUTION

inherit
	WSF_ROUTED_EXECUTION
		redefine
			execute_default
		end

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_EXECUTION

create
	make

feature {NONE} -- Initialization

	setup_router
		local
			ra: WSF_URI_TEMPLATE_AGENT_HANDLER
			hello: WSF_URI_TEMPLATE_ROUTING_HANDLER
			www: WSF_FILE_SYSTEM_HANDLER
		do
			map_uri_template_agent ("/refresh", agent execute_refresh, Void)
			map_uri_template_agent ("/home", agent execute_home, Void)
			create www.make (document_root)
			www.set_directory_index (<<"index.html">>)
			router.handle ("/www{/path}{?query}", www, Void)

			--| Map all "/hello*" using a ROUTING_HANDLER
			create hello.make (3)
			router.handle ("/hello", hello, Void)

			create ra.make (agent handle_hello)
			hello.router.handle ("/hello/{name}.{format}", ra, Void)
			hello.router.handle ("/hello.{format}/{name}", ra, Void)
			hello.router.handle ("/hello/{name}", ra, Void)

			create ra.make (agent handle_anonymous_hello)
			hello.router.handle ("/hello", ra, Void)
			hello.router.handle ("/hello.{format}", ra, Void)

			--| Various various route, directly on the "router"
			map_uri_template_agent ("/method/any", agent handle_method_any, Void)
			map_uri_template_agent ("/method/guess", agent handle_method_get_or_post, <<"GET", "POST">>)
			map_uri_template_agent ("/method/custom", agent handle_method_get, <<"GET">>)
			map_uri_template_agent ("/method/custom", agent handle_method_post, <<"POST">>)
		end


	document_root: READABLE_STRING_8
		local
			e: EXECUTION_ENVIRONMENT
			dn: DIRECTORY_NAME
		once
			create e
			create dn.make_from_string (e.current_working_directory)
			dn.extend ("htdocs")
			Result := dn.string
			if Result[Result.count] = Operating_environment.directory_separator then
				Result := Result.substring (1, Result.count - 1)
			end
		end

feature -- Execution


	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_url: STRING
		do
			l_url := req.absolute_script_url ("/home")
			res.redirect_now_with_content (l_url, "You are now being redirected to " + l_url, {HTTP_MIME_TYPES}.text_html)
		end

	execute_refresh	(req: WSF_REQUEST; res: WSF_RESPONSE) --ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT;
		local
			h: HTTP_HEADER
			l_url: STRING
			e: EXECUTION_ENVIRONMENT
			n: INTEGER
			i: INTEGER
			s: STRING_8
		do
			l_url := req.absolute_script_url ("/home")



			n := 3
			create h.make
			h.put_refresh (l_url, 5)
			h.put_location (l_url)
			h.put_content_type_text_plain
			h.put_transfer_encoding_chunked
--			h.put_content_length (0)
--			res.set_status_code ({HTTP_STATUS_CODE}.moved_permanently)
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)

			from
				create e
				create s.make (255)
			until
				n = 0
			loop
				if n > 1 then
					s.append ("%NRedirected to " + l_url + " in " + n.out + " seconds :%N")
				else
					s.append ("%NRedirected to " + l_url + " in 1 second :%N")
				end
				res.put_chunk (s, Void); s.wipe_out
				from
					i := 1
				until
					i = 1001
				loop
					s.append_character ('.')
					if i \\ 100 = 0 then
						s.append_character ('%N')
					end
					res.put_chunk (s, Void); s.wipe_out
					e.sleep (1_000_000)
					i := i + 1
				end
				n := n - 1
			end
			s.append ("%NYou are now being redirected...%N")
			res.put_chunk (s, Void); s.wipe_out
			res.put_chunk_end
		end

	execute_home (req: WSF_REQUEST; res: WSF_RESPONSE) -- ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT;
		local
			l_body: STRING_8
		do
			create l_body.make (255)
			l_body.append ("<html><body>Hello World ?!%N")
			l_body.append ("<h3>Please try the following links</h3><ul>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/") + "%">default</a></li>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/refresh") + "%">redirect using refresh and chunked encoding</a></li>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/hello") + "%">/hello</a></li>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/hello.html/Joce") + "%">/hello.html/Joce</a></li>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/hello.json/Joce") + "%">/hello.json/Joce</a></li>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/hello/Joce.html") + "%">/hello/Joce.html</a></li>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/hello/Joce.xml") + "%">/hello/Joce.xml</a></li>%N")
			l_body.append ("<li><a href=%""+ req.script_url ("/hello/Joce") + "%">/hello/Joce</a></li>%N")
			l_body.append ("</ul>%N")
			if attached req.item ("REQUEST_COUNT") as rqc then
				l_body.append ("request #"+ rqc.as_string.url_encoded_value + "%N")
			end
			l_body.append ("</body></html>%N")

			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_body.count.out]>>)
			res.put_string (l_body)
		end

	execute_hello (req: WSF_REQUEST; res: WSF_RESPONSE; a_name: detachable READABLE_STRING_32)
		local
			l_response_content_type: detachable STRING
			h: HTTP_HEADER
			content_type_supported: ARRAY [STRING]
			l_body: STRING_8
			l_format: detachable READABLE_STRING_GENERAL
			l_http_format_constants: HTTP_FORMAT_CONSTANTS
		do
			if a_name /= Void then
				l_body := "Hello %"" + a_name + "%" !%N"
			else
				l_body := "Hello anonymous visitor !%N"
			end
			content_type_supported := <<{HTTP_MIME_TYPES}.application_json, {HTTP_MIME_TYPES}.text_html, {HTTP_MIME_TYPES}.text_xml, {HTTP_MIME_TYPES}.text_plain>>
			if attached {WSF_STRING} req.path_parameter ("format") as s_format then
				l_format := s_format.value
			end
			if l_format = Void then
				across
					content_type_supported as ic
				until
					l_format /= Void
				loop
					if req.is_content_type_accepted (ic.item) then
						l_format := ic.item
					end
				end
			end
			if l_format /= Void then
				create l_http_format_constants
				inspect
					l_http_format_constants.format_id (l_format)
				when {HTTP_FORMAT_CONSTANTS}.json then
					l_response_content_type := {HTTP_MIME_TYPES}.application_json
					l_body := "{%N%"application%": %"/hello%",%N %"message%": %"" + l_body + "%" %N}"
				when {HTTP_FORMAT_CONSTANTS}.html then
					l_response_content_type := {HTTP_MIME_TYPES}.text_html
				when {HTTP_FORMAT_CONSTANTS}.xml then
					l_response_content_type := {HTTP_MIME_TYPES}.text_xml
					l_body := "<response><application>/hello</application><message>" + l_body + "</message></response>%N"
				when {HTTP_FORMAT_CONSTANTS}.text then
					l_response_content_type := {HTTP_MIME_TYPES}.text_plain
				else
					l_response_content_type := Void
				end
			end

			if l_response_content_type /= Void then
				create h.make
				h.put_content_type (l_response_content_type)
				h.put_content_length (l_body.count)
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_body)
			else
				res.send (create {WSF_PRECONDITION_FAILED_MESSAGE}.make (req)) -- FIXME: better error message!
			end
		end

	string_path_parameter (req: WSF_REQUEST; a_name: READABLE_STRING_GENERAL): detachable STRING_32
		do
			if attached {WSF_STRING} req.path_parameter (a_name) as s then
				Result := s.value
			end
		end

	handle_hello (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, string_path_parameter (req, "name"))
		end

	handle_anonymous_hello (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, string_path_parameter (req, "name"))
		end

	handle_method_any (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, req.request_method)
		end

	handle_method_get (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, "GET")
		end


	handle_method_post (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, "POST")
		end

	handle_method_get_or_post (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, "GET or POST")
		end



note
	copyright: "2011-2016, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
