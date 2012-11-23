note
	description: "[
				Response message to send a self documentation of the WSF_ROUTER
				This is using in addition WSF_SELF_DOCUMENTED_ROUTER_MAPPING and WSF_SELF_DOCUMENTED_HANDLER
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ROUTER_SELF_DOCUMENTATION_MESSAGE

inherit
	WSF_RESPONSE_MESSAGE

create
	make

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; a_router: WSF_ROUTER; a_resource: detachable STRING)
		local

		do
			request := req
			router := a_router
			if attached a_router.base_url as l_base_url then
				resource := l_base_url.twin
			else
				create resource.make_empty
			end
			if a_resource /= Void then
				resource.append (a_resource)
			end
		end

	request: WSF_REQUEST

	router: WSF_ROUTER

	resource: STRING_8

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
			-- Send Current message to `res'
			--
			-- This feature should be called via `{WSF_RESPONSE}.send (obj)'
			-- where `obj' is the current object
		local
			h: HTTP_HEADER
			l_description: STRING_8
			l_base_url: STRING_8
			l_api_resource: detachable STRING_8
		do
			create h.make
			h.put_content_type_text_html
			create l_description.make (1024)
			l_description.append ("<html>")
			l_description.append ("<head>")
			l_description.append ("<title>Documentation</title>")
			l_description.append ("[
					<style type="text/css">
						.mappingresource { color: #00f; } 
						.mappingdoc { color: #900; }
						.handlerdoc { white-space: pre; }
						div#footer { padding: 10px; width: 100%; margin-top: 20px;  border-top: 1px dotted #999; color: #999; text-align: center; }
					</style>
					]")

			l_description.append ("</head><body>")

			l_description.append ("<h1>Documentation</h1>%N")

			if attached router.base_url as u then
				l_base_url := u
			else
				create l_base_url.make_empty
			end

			debug
				l_description.append ("<h2>Meta</h2><ul>")
				l_description.append ("<li>PATH_INFO=" + request.path_info + "</li>")
				l_description.append ("<li>QUERY_STRING=" + request.query_string + "</li>")
				l_description.append ("<li>REQUEST_URI=" + request.request_uri + "</li>")
				l_description.append ("<li>SCRIPT_NAME=" + request.script_name + "</li>")
				l_description.append ("<li>HOME=" + request.script_url ("/") + "</li>")
				if not l_base_url.is_empty then
					l_description.append ("<li>Base URL=" + l_base_url + "</li>")
				end
				l_description.append ("</ul>")
			end

			if attached request.path_info as l_path then
				if l_path.starts_with (resource) then
					l_api_resource := l_path.substring (resource.count + 1, l_path.count)
					if l_api_resource.is_empty then
						l_api_resource := Void
					end
				end
			end

			if l_api_resource /= Void then
				l_description.append ("<a href=%""+ doc_url ("") +"%">Index</a><br/>")
				if attached router.item_associated_with_resource (l_api_resource, Void) as l_api_item then
					l_description.append ("<h2>Information related to %"" + l_api_resource + "%"</h2><ul>")
					append_documentation_to (l_description, l_api_item.mapping, l_api_item.request_methods)
					l_description.append ("</ul>")
				end
			else
				l_description.append ("<h2>Router</h2><ul>")
				across
					router as c
				loop
					append_documentation_to (l_description, c.item.mapping, c.item.request_methods)
				end
				l_description.append ("</ul>")
			end


			l_description.append ("<div id=%"footer%">-- Self generated documentation --</div>%N")
			l_description.append ("</body></html>")

			h.put_content_length (l_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_description)
		end

	append_documentation_to (s: STRING_8; m: WSF_ROUTER_MAPPING; meths: detachable WSF_ROUTER_METHODS)
		local
			l_url: detachable STRING_8
			l_base_url: detachable READABLE_STRING_8
			hdl: WSF_HANDLER
		do
			l_base_url := router.base_url
			if l_base_url = Void then
				l_base_url := ""
			end

			l_url := Void
			s.append ("<li>")
			s.append ("<code>")
			s.append ("<a class=%"mappingresource%" href=%"")
			s.append (doc_url (m.associated_resource))
			s.append ("%">")
			s.append (m.associated_resource)
			s.append ("</a></code>")

			if attached {WSF_SELF_DOCUMENTED_ROUTER_MAPPING} m as l_doc_mapping then
				s.append (" <em class=%"mappingdoc%">" + html_encoder.encoded_string (l_doc_mapping.documentation) + "</em> ")
			else
				debug
					s.append (" <em class=%"mappingdoc%">" + m.generating_type.out + "</em> ")
				end
			end
			if meths /= Void then
				s.append (" [ ")
				across
					meths as rq
				loop
					if l_url /= Void and then rq.item.is_case_insensitive_equal ("GET") then
						s.append ("<a href=%"" + l_base_url + l_url + "%">" + rq.item + "</a>")
					else
						s.append (rq.item)
					end
					if not rq.is_last then
						s.append (",")
					end
					s.append (" ")
				end
				s.append ("]")
			end

			hdl := m.handler
			if attached {WSF_SELF_DOCUMENTED_HANDLER} hdl as l_doc_handler and then attached l_doc_handler.documentation as l_doc then
				s.append ("%N<ul class=%"handlerdoc%">")
				s.append (html_encoder.encoded_string (l_doc))
				s.append ("%N</ul>%N")
			else
				debug
					s.append ("%N<ul class=%"handlerdoc%">")
					s.append (hdl.generating_type.out)
					s.append ("%N</ul>%N")
				end
			end
			if attached {WSF_ROUTING_HANDLER} hdl as l_routing_hdl then
				s.append ("%N<ul>%N")
				across
					l_routing_hdl.router as c
				loop
					append_documentation_to (s, c.item.mapping, c.item.request_methods)
				end
				s.append ("%N</ul>%N")
			end
			s.append ("</li>%N")
		end

feature {NONE} -- Implementation

	doc_url (a_api: STRING_8): STRING_8
		do
			Result := request.script_url (resource + url_encoder.encoded_string (a_api))
		end

	html_encoder: HTML_ENCODER
		once
			create Result
		end

	url_encoder: URL_ENCODER
		once
			create Result
		end

end
