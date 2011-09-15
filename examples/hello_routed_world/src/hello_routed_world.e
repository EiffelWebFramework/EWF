note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HELLO_ROUTED_WORLD

inherit
	ANY

	URI_TEMPLATE_ROUTED_APPLICATION

	ROUTED_APPLICATION_HELPER

	DEFAULT_WGI_APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize_router
			make_and_launch
		end

	create_router
		do
			create router.make (5)
		end

	setup_router
		local
			ra: REQUEST_AGENT_HANDLER [REQUEST_URI_TEMPLATE_HANDLER_CONTEXT]
			rag: REQUEST_URI_TEMPLATE_ROUTING_HANDLER
		do
			router.map_agent ("/home", agent execute_home)

			create rag.make (3)

			create ra.make (agent handle_hello)
			rag.map ("/hello/{name}.{format}", ra)
			rag.map ("/hello.{format}/{name}", ra)
			rag.map ("/hello/{name}", ra)
--			router.map ("/hello/{name}.{format}", ra)
--			router.map ("/hello.{format}/{name}", ra)
--			router.map ("/hello/{name}", ra)

			create ra.make (agent handle_anonymous_hello)
			rag.map ("/hello", ra)
			rag.map ("/hello.{format}", ra)
--			router.map ("/hello", ra)
--			router.map ("/hello.{format}", ra)

			router.map ("/hello", rag)

			router.map_agent_with_request_methods ("/method/any", agent handle_method_any, Void)
			router.map_agent_with_request_methods ("/method/guess", agent handle_method_get_or_post, <<"GET", "POST">>)
			router.map_agent_with_request_methods ("/method/custom", agent handle_method_get, <<"GET">>)
			router.map_agent_with_request_methods ("/method/custom", agent handle_method_post, <<"POST">>)

		end

feature -- Execution

	execute_default (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			h: EWF_HEADER
			l_url: STRING
			e: EXECUTION_ENVIRONMENT
			n: INTEGER
			i: INTEGER
		do
			create h.make
			l_url := req.script_url ("/home")
			n := 3
			h.put_refresh (l_url, 5, 200)
			res.set_status_code (200)
			res.write_headers_string (h.string)
			from
				create e
			until
				n = 0
			loop
				if n > 1 then
					res.write_string ("Redirected to " + l_url + " in " + n.out + " seconds :%N")
				else
					res.write_string ("Redirected to " + l_url + " in 1 second :%N")
				end
				res.flush
				from
					i := 1
				until
					i = 1001
				loop
					res.write_string (".")
					if i \\ 100 = 0 then
						res.write_string ("%N")
					end
					res.flush
					e.sleep (1_000_000)
					i := i + 1
				end
				res.write_string ("%N")
				n := n - 1
			end
			res.write_string ("You are now being redirected...%N")
			res.flush
		end

	execute_home (ctx: REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			res.write_header (200, <<["Content-Type", "text/html"]>>)
			res.write_string ("<html><body>Hello World ?!%N")
			res.write_string ("<h3>Please try the following links</h3><ul>%N")
			res.write_string ("<li><a href=%""+ req.script_url ("/") + "%">default</a></li>%N")
			res.write_string ("<li><a href=%""+ req.script_url ("/hello") + "%">/hello</a></li>%N")
			res.write_string ("<li><a href=%""+ req.script_url ("/hello.html/Joce") + "%">/hello.html/Joce</a></li>%N")
			res.write_string ("<li><a href=%""+ req.script_url ("/hello.json/Joce") + "%">/hello.json/Joce</a></li>%N")
			res.write_string ("<li><a href=%""+ req.script_url ("/hello/Joce.html") + "%">/hello/Joce.html</a></li>%N")
			res.write_string ("<li><a href=%""+ req.script_url ("/hello/Joce.xml") + "%">/hello/Joce.xml</a></li>%N")
			res.write_string ("<li><a href=%""+ req.script_url ("/hello/Joce") + "%">/hello/Joce</a></li>%N")
			res.write_string ("</ul>%N")

			if attached req.item ("REQUEST_COUNT") as rqc then
				res.write_string ("request #"+ rqc.as_string + "%N")
			end
			res.write_string ("</body></html>%N")
		end

	execute_hello (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER; a_name: detachable READABLE_STRING_32; ctx: REQUEST_HANDLER_CONTEXT)
		local
			l_response_content_type: detachable STRING
			msg: STRING
			h: EWF_HEADER
			content_type_supported: ARRAY [STRING]
		do
			if a_name /= Void then
				msg := "Hello %"" + a_name + "%" !%N"
			else
				msg := "Hello anonymous visitor !%N"
			end
			content_type_supported := <<{HTTP_CONSTANTS}.json_app, {HTTP_CONSTANTS}.html_text, {HTTP_CONSTANTS}.xml_text, {HTTP_CONSTANTS}.plain_text>>
			inspect ctx.request_format_id ("format", content_type_supported)
			when {HTTP_FORMAT_CONSTANTS}.json then
				l_response_content_type := {HTTP_CONSTANTS}.json_app
				msg := "{%N%"application%": %"/hello%",%N %"message%": %"" + msg + "%" %N}"
			when {HTTP_FORMAT_CONSTANTS}.html then
				l_response_content_type := {HTTP_CONSTANTS}.html_text
			when {HTTP_FORMAT_CONSTANTS}.xml then
				l_response_content_type := {HTTP_CONSTANTS}.xml_text
				msg := "<response><application>/hello</application><message>" + msg + "</message></response>%N"
			when {HTTP_FORMAT_CONSTANTS}.text then
				l_response_content_type := {HTTP_CONSTANTS}.plain_text
			else
				execute_content_type_not_allowed (req, res,	content_type_supported,
						<<{HTTP_FORMAT_CONSTANTS}.json_name, {HTTP_FORMAT_CONSTANTS}.html_name, {HTTP_FORMAT_CONSTANTS}.xml_name, {HTTP_FORMAT_CONSTANTS}.text_name>>
						)
			end
			if l_response_content_type /= Void then
				create h.make
				h.put_status (200)
				h.put_content_type (l_response_content_type)
				h.put_content_length (msg.count)
				res.set_status_code (200)
				res.write_headers_string (h.string)
--				res.write_header (200, <<
--						["Content-Type", l_response_content_type],
--						["Content-Length", msg.count.out
--						>>)
				res.write_string (msg)
			end
		end

	handle_hello (ctx: REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			execute_hello (req, res, Void, ctx)
		end

	handle_anonymous_hello (ctx: REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			execute_hello (req, res, ctx.string_parameter ("name"), ctx)
		end

	handle_method_any (ctx: REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			execute_hello (req, res, req.request_method, ctx)
		end

	handle_method_get (ctx: REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			execute_hello (req, res, "GET", ctx)
		end


	handle_method_post (ctx: REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			execute_hello (req, res, "POST", ctx)
		end

	handle_method_get_or_post (ctx: REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
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
