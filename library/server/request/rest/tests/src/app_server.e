note
	description: "Summary description for {APP_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APP_SERVER

inherit
	APP_SERVICE
		redefine
			execute
		end

	REST_SERVICE_GATEWAY

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			initialize_router
			build_gateway_and_launch
		end

feature {NONE} -- Handlers		

	create_router
			-- Create `router'	
		do
			create router.make (5)
		end

	setup_router
		local
			h: APP_REQUEST_HANDLER
			rah: APP_REQUEST_AGENT_HANDLER
			gh: APP_REQUEST_ROUTING_HANDLER
		do
			create {APP_ACCOUNT_VERIFY_CREDENTIAL} h.make
			router.map ("/account/verify_credentials", h)
			router.map ("/account/verify_credentials.{format}", h)


			create {APP_TEST} h.make

			create gh.make (4)
			router.map ("/test", gh)
			gh.map_default (h)
--			gh.map ("/test", h)
			gh.map ("/test/{op}", h)
			gh.map ("/test.{format}", h)
			gh.map ("/test.{format}/{op}", h)


			create rah.make (agent execute_exit_application)
			h := rah
			h.set_description ("tell the REST server to exit (in FCGI context, this is used to reload the FCGI server)")
			h.enable_request_method_get
			h.enable_format_text
			router.map ("/debug/exit", h)
			router.map ("/debug/exit.{format}", h)
		end

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			request_count := request_count + 1
			Precursor (req, res)
		end

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			rqst_uri: detachable STRING
			l_path_info: detachable STRING
			h: WSF_HEADER
			s: STRING
			l_redir_url: STRING
		do
			create h.make
--			h.put_refresh (ctx.script_url ("/doc"), 2)
			l_redir_url := "/doc"
			h.put_refresh (l_redir_url, 2)
			h.put_content_type_text_html
			create s.make_empty
			s := "Request [" + req.path_info + "] is not available. <br/>%N";
			s.append ("You are being redirected to <a href=%"" + l_redir_url + "%">/doc</a> in 2 seconds ...%N")
			h.put_content_length (s.count)
			res.set_status_code ({HTTP_STATUS_CODE}.temp_redirect)
			res.write_headers_string (h.string)
			res.write_string (s)
		end

	request_count: INTEGER

--	execute_rescue (ctx: like new_request_context)
--			-- Execute the default rescue behavior
--		do
--			execute_exception_trace (ctx)
--		end

feature -- Implementation

--	execute_exception_trace (ctx: like new_request_context)
--		local
--			h: WSF_HEADER
--			s: STRING
--		do
--			create h.make
--			h.put_content_type_text_plain
--			ctx.output.put_string (h.string)
--			ctx.output.put_string ("Error occurred .. rq="+ request_count.out +"%N")

--			if attached (create {EXCEPTIONS}).exception_trace as l_trace then
--				ctx.output.put_string ("<pre>" + l_trace + "</pre>")
--			end
--			h.recycle
--			exit_with_code (-1)
--		end

	execute_exit_application (ctx: APP_REQUEST_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			s: STRING
		do
			res.set_status_code (200)
			res.write_header (200, <<["Content-Type", "text/html"]>>)

			create s.make_empty
			s.append_string ("Exited")
			s.append_string (" <a href=%"" + ctx.script_url ("/") + "%">start again</a>%N")
			res.write_string (s)
			exit_with_code (0)
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
