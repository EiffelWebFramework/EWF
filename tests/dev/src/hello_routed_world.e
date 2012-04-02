note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HELLO_ROUTED_WORLD

inherit
	WSF_URI_TEMPLATE_ROUTED_SERVICE

	WSF_HANDLER_HELPER

	WSF_DEFAULT_SERVICE

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize_router
			set_service_option ("port", 8099)
			make_and_launch
		end

	create_router
		do
			create router.make (5)
		end

	setup_router
		local
			ra: WSF_AGENT_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT]
			hello: WSF_URI_TEMPLATE_ROUTING_HANDLER
			www: WSF_FILE_SYSTEM_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT]
		do
			router.map_agent ("/refresh", agent execute_refresh)
			router.map_agent ("/home", agent execute_home)
			create www.make (document_root)
			www.set_directory_index (<<"index.html">>)

			router.map ("/www{/path}{?query}", www)

			--| Map all "/hello*" using a ROUTING_HANDLER
			create hello.make (3)
			router.map ("/hello", hello)

			create ra.make (agent handle_hello)
			hello.map ("/hello/{name}.{format}", ra)
			hello.map ("/hello.{format}/{name}", ra)
			hello.map ("/hello/{name}", ra)

			create ra.make (agent handle_anonymous_hello)
			hello.map ("/hello", ra)
			hello.map ("/hello.{format}", ra)

			--| Various various route, directly on the "router"
			router.map_agent_with_request_methods ("/method/any", agent handle_method_any, Void)
			router.map_agent_with_request_methods ("/method/guess", agent handle_method_get_or_post, <<"GET", "POST">>)
			router.map_agent_with_request_methods ("/method/custom", agent handle_method_get, <<"GET">>)
			router.map_agent_with_request_methods ("/method/custom", agent handle_method_post, <<"POST">>)
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

	execute_refresh	(ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
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

	execute_home (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
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
				l_body.append ("request #"+ rqc.as_string.string + "%N")
			end
			l_body.append ("</body></html>%N")

			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_body.count.out]>>)
			res.put_string (l_body)
		end

	execute_hello (req: WSF_REQUEST; res: WSF_RESPONSE; a_name: detachable READABLE_STRING_32; ctx: WSF_HANDLER_CONTEXT)
		local
			l_response_content_type: detachable STRING
			h: HTTP_HEADER
			content_type_supported: ARRAY [STRING]
			l_body: STRING_8
		do
			if a_name /= Void then
				l_body := "Hello %"" + a_name + "%" !%N"
			else
				l_body := "Hello anonymous visitor !%N"
			end
			content_type_supported := <<{HTTP_MIME_TYPES}.application_json, {HTTP_MIME_TYPES}.text_html, {HTTP_MIME_TYPES}.text_xml, {HTTP_MIME_TYPES}.text_plain>>
			inspect ctx.request_format_id ("format", content_type_supported)
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
				execute_content_type_not_allowed (req, res,	content_type_supported,
						<<{HTTP_FORMAT_CONSTANTS}.json_name, {HTTP_FORMAT_CONSTANTS}.html_name, {HTTP_FORMAT_CONSTANTS}.xml_name, {HTTP_FORMAT_CONSTANTS}.text_name>>
						)
			end
			if l_response_content_type /= Void then
				create h.make
				h.put_content_type (l_response_content_type)
				h.put_content_length (l_body.count)
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_body)
			end
		end

	handle_hello (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, ctx.string_parameter ("name"), ctx)
		end

	handle_anonymous_hello (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, ctx.string_parameter ("name"), ctx)
		end

	handle_method_any (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, req.request_method, ctx)
		end

	handle_method_get (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, "GET", ctx)
		end


	handle_method_post (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, "POST", ctx)
		end

	handle_method_get_or_post (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			execute_hello (req, res, "GET or POST", ctx)
		end



note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
