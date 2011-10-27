note
	description: "Summary description for {REST_API_DOCUMENTATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_API_DOCUMENTATION [C -> REST_REQUEST_HANDLER_CONTEXT]

inherit
	REST_REQUEST_HANDLER [C]

create
	make

feature {NONE} -- Initialization

	make (a_router: like router; a_base_doc_url: like base_doc_url)
		do
			router := a_router
			base_doc_url := a_base_doc_url
			description := "Technical documention for the API"
		end

feature {NONE} -- Access: Implementation

	router: REST_REQUEST_ROUTER [REST_REQUEST_HANDLER [C], C]

	base_doc_url: READABLE_STRING_8

feature -- Access

	authentication_required (req: WSF_REQUEST): BOOLEAN
		do
		end

feature -- Execution

	execute_application (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			rep: like new_html_page
			s: STRING
			rq: detachable REST_REQUEST_HANDLER [C]
			rq_resource: detachable READABLE_STRING_GENERAL
--			l_dft_format_name: detachable STRING
			hdl_cursor: like router.new_cursor
		do
			rep := new_html_page
			rep.headers.put_content_type_text_html
			create s.make_empty

			if
				attached {WSF_STRING_VALUE} ctx.path_parameter ("resource") as l_resource_value and then
				attached l_resource_value.string as l_resource
			then
				from
					hdl_cursor := router.new_cursor
				until
					hdl_cursor.after or rq /= Void
				loop
					if hdl_cursor.item.resource.same_string_general (l_resource) then
						rq := hdl_cursor.item.handler
						rq_resource := l_resource
					end
					hdl_cursor.forth
				end
			end
--			if a_args /= Void and then not a_args.is_empty then
--				rq := router.handler_by_path (a_args)
--				if rq = Void then
--					rq := handler_manager.smart_handler_by_path (a_args)
----					if attached {REST_REQUEST_GROUP_HANDLER} rq as grp then
----						rq := grp.handlers.handler_by_path (a_args)
----					end
--				end
--				if
--					rq /= Void and then
--					attached rq.path_information (a_args) as l_info
--				then
--					l_dft_format_name := l_info.format
--				end
--			end


			if rq /= Void and then rq_resource /= Void then
				rep.set_big_title ("API: Technical documentation for ["+ rq_resource.as_string_8 +"]")

				s.append_string ("<div class=%"api%">")
				s.append_string ("<h2 class=%"api-name%" >")

				s.append_string ("<a href=%"" + base_doc_url + "%">.. Show all features ..</a>")
				s.append_string ("</h2></div>%N")

				process_request_handler_doc (rq, rq_resource.as_string_8, s, ctx, req, res, Void)
			else
				rep.set_big_title ("API: Technical documentation")

				from
					hdl_cursor := router.new_cursor
				until
					hdl_cursor.after
				loop
					if attached hdl_cursor.item as l_item then
						rq := l_item.handler
						rep.add_shortcut (l_item.resource)
						s.append ("<a name=%"" + rep.last_added_shortcut + "%"/>")
						process_request_handler_doc (rq, l_item.resource, s, ctx, req, res, Void)
						hdl_cursor.forth
					end
				end
			end
			rep.set_body (s)
			rep.send (res)
			rep.recycle
		end

	process_request_handler_doc (rq: REST_REQUEST_HANDLER [C]; a_resource: STRING; buf: STRING; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE; a_dft_format: detachable STRING)
		local
			l_dft_format_name: detachable STRING
			s: STRING
			l_uri_tpl: URI_TEMPLATE
		do
			s := buf

			if a_dft_format /= Void then
				if rq.supported_format_names.has (a_dft_format) then
					l_dft_format_name := a_dft_format
				end
			end

			s.append_string ("<div class=%"api%">")
			s.append_string ("<h2 class=%"api-name%" ><a href=%""+ url (req, base_doc_url, a_resource, False) +"%">"+ a_resource +"</a></h2>")
			s.append_string ("<div class=%"inner%">")
--			if rq.hidden (req) then
--				s.append_string ("<div class=%"api-description%">This feature is hidden</div>%N")
--			else
				if attached rq.description as desc then
					s.append_string ("<div class=%"api-description%">" + desc + "</div>")
				end
--				if attached {REST_REQUEST_GROUP_HANDLER} rq as grp then
--					s.append_string ("<div class=%"api-format%">Handler: <strong>")
--					if attached grp.handlers.new_cursor as l_handlers_cursor then
--						from

--						until
--							l_handlers_cursor.after
--						loop
--							s.append_string (" ")
--							s.append_string ("<a class=%"api-handler%" href=%"")
--							s.append_string (url (ctx, l_handlers_cursor.item.path, False))
--							s.append_string ("%">"+ l_handlers_cursor.item.path +"</a>")
--							l_handlers_cursor.forth
--						end
--					end
--					s.append_string ("</strong></div>")
--				end
				if attached rq.supported_format_names as l_formats and then not l_formats.is_empty then
					s.append_string ("<div class=%"api-format%">Supported formats: <strong>")
					if attached l_formats.new_cursor as l_formats_cursor then
						from

						until
							l_formats_cursor.after
						loop
							s.append_string (" ")
							s.append_string ("<a class=%"api-name api-format")
							if l_formats_cursor.item ~ l_dft_format_name then
								s.append_string (" selected")
							end
							s.append_string ("%" href=%"" + url (req, base_doc_url, a_resource, False) + "." + l_formats_cursor.item + "%">"+ l_formats_cursor.item +"</a>")
							l_formats_cursor.forth
						end
					end
					s.append_string ("</strong></div>")
				end
				if attached rq.supported_request_method_names as l_methods and then not l_methods.is_empty then
					s.append_string ("<div class=%"api-method%">Supported request methods: <strong>")
					if attached l_methods.new_cursor as l_methods_cursor then
						from

						until
							l_methods_cursor.after
						loop
							s.append_string (" ")
							s.append_string (l_methods_cursor.item)
							l_methods_cursor.forth
						end
					end
					s.append_string ("</strong></div>")
				end
				s.append_string ("<div class=%"api-auth%">Authentication required: <strong>" + rq.authentication_required (req).out + "</strong></div>")
				if attached {REST_REQUEST_URI_TEMPLATE_ROUTER_I [REST_REQUEST_HANDLER [REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT], REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT]} router as l_uri_template_router then
					create l_uri_tpl.make (a_resource)
					if attached l_uri_tpl.query_variable_names as l_query_variable_names and then not l_query_variable_names.is_empty then
						s.append_string ("<div class=%"api-uri-template%">Query parameters: ")
--						s.append_string (rq.path)
						from
							l_query_variable_names.start
						until
							l_query_variable_names.after
						loop
							if l_query_variable_names.isfirst then
								s.append_string ("?")
							else
								s.append_string ("&")
							end
							if attached l_query_variable_names.item as l_query_param then
								s.append_string ("<strong>" + l_query_param + "</strong>")
								s.append_string ("=<em>" + l_query_param + "</em>")
							end
							l_query_variable_names.forth
						end
						s.append_string ("</div>%N")
					end
					if attached l_uri_tpl.path_variable_names as l_path_variable_names and then not l_path_variable_names.is_empty then
						s.append_string ("<div class=%"api-uri-template%">Path Segment parameters: ")
--						s.append_string (rq.path)
						from
							l_path_variable_names.start
						until
							l_path_variable_names.after
						loop
							if attached l_path_variable_names.item as l_seg_param then
								s.append_string ("<em>{" + l_seg_param + "}</em>")
							end
							l_path_variable_names.forth
						end
						s.append_string ("</div>%N")
					end

				end
--				if attached rq._parameters as l_uri_params and then not l_uri_params.is_empty then
--					s.append_string ("<div class=%"api-uri-template%">URI Template: ")
--					s.append_string (rq.path)
--					if attached l_uri_params.new_cursor as l_uri_params_cursor then
--						from

--						until
--							l_uri_params_cursor.after
--						loop
--							if attached l_uri_params_cursor.item as l_uri_param then
--								s.append_string ("/<strong>" + l_uri_param.name + "</strong>")
--								s.append_string ("/<em>{" + l_uri_param.name + "}</em>")
--							end
--							l_uri_params_cursor.forth
--						end
--					end
--					s.append_string ("</div>%N")
--				end
--				if attached rq.parameters as l_params and then not l_params.is_empty then
--					s.append_string ("<div class=%"api-params%">Parameters: ")

--						--| show form only if we have a default format
--					if l_dft_format_name = Void then
--						s.append_string ("<span class=%"note%">to test the parameter(s), please first select a supported format.</span>%N")
--					else
--						if rq.method_post_supported then
--							s.append_string ("<form id=%""+ rq.path +"%" method=%"POST%" action=%"" + ctx.script_url (rq.path) + "." + l_dft_format_name + "%">%N")
--						else
--							s.append_string ("<form id=%""+ rq.path +"%" method=%"GET%" action=%"" + ctx.script_url (rq.path) + "." + l_dft_format_name + "%">%N")
--						end
--					end
--					s.append_string ("<ul>")
--					if attached l_params.new_cursor as l_params_cursor then
--						from

--						until
--							l_params_cursor.after
--						loop
--							if attached l_params_cursor.item as l_param then
--								s.append_string ("<li><strong>" + l_param.name + "</strong>")
--								if l_param.optional then
--									s.append_string (" <em>(Optional)</em>")
--								end
--								if attached l_param.description as l_param_desc then
--									s.append_string (": <em>" + l_param_desc + "</em>")
--								end
--								if l_dft_format_name /= Void then
--									s.append (" <input name=%"" + l_param.name + "%" type=%"text%" />")
--								end
--								s.append_string ("</li>")
--							end
--							l_params_cursor.forth
--						end
--					end

--					if l_dft_format_name /= Void then
--						s.append_string ("<input type=%"submit%" value=%"Test "+ rq.path + "." + l_dft_format_name + "%"/>")
--						s.append_string ("</form>")
--					end
--					s.append_string ("</ul></div>")
--				else
--					if l_dft_format_name /= Void then
--						s.append_string ("<a class=%"api-name%" href=%"" + ctx.script_url (a_resource + "." + l_dft_format_name) + "%">Test "+ a_resource  + "." + l_dft_format_name + "</a>")
--					else
--						s.append_string ("<a class=%"api-name%" href=%"" + ctx.script_url (a_resource) + "%">Test "+ a_resource +"</a>")
--					end
--				end
				s.append_string ("</div>%N")
--			end
			s.append_string ("</div>%N") -- inner
		end

feature -- Access

	new_html_page: REST_API_DOCUMENTATION_HTML_PAGE
		do
			create Result.make ("API Documentation")
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
