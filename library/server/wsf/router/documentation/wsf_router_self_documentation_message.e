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
		do
			request := req
			router := a_router
			if a_resource /= Void and then attached a_router.base_url as l_base_url then
				resource := l_base_url + a_resource
			end
		end

feature -- Access		

	request: WSF_REQUEST

	router: WSF_ROUTER

	resource: detachable STRING_8

feature -- Properties

	header: detachable STRING_8
			-- Header's content for the output HTML.

	footer: detachable STRING_8
		-- Footer's content for the output HTML.

	custom_style_url: detachable STRING_8
		-- URL for a custom style css document.

feature -- Change

	set_header (v: like header)
		do
			header := v
		end

	set_footer (v: like footer)
		do
			footer := v
		end

	set_custom_style_url (v: like custom_style_url)
		do
			custom_style_url := v
		end

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
			if attached custom_style_url as l_custom_style_url then
				l_description.append ("<link rel=%"stylesheet%" type=%"text/css%" href=%""+ l_custom_style_url +"%"/>%N")
			else
				l_description.append ("[
						<style type="text/css">
							.mappingresource { color: #00f; }
							.mappingdoc { color: #900; }
							.handlerdoc { white-space: pre; }
							div#footer { padding: 10px; width: 100%; margin-top: 20px;  border-top: 1px dotted #999; color: #999; text-align: center; }
						</style>
						]")
			end

			l_description.append ("</head><body>")
			if attached header as l_header then
				l_description.append (l_header)
			end

			l_description.append ("<h1>Documentation</h1>%N")

			if attached router.base_url as u then
				l_base_url := u
			else
				create l_base_url.make_empty
			end

			debug
				l_description.append ("<h2>Meta Information</h2><ul>")
				l_description.append ("<li>PATH_INFO=" + request.path_info + "</li>")
				l_description.append ("<li>QUERY_STRING=" + request.query_string + "</li>")
				l_description.append ("<li>REQUEST_URI=" + request.request_uri + "</li>")
				l_description.append ("<li>SCRIPT_NAME=" + request.script_name + "</li>")
				if not l_base_url.is_empty then
					l_description.append ("<li>Router's Base URL=" + l_base_url + "</li>")
				end
				l_description.append ("</ul>")
			end

			if doc_url_supported and then attached {WSF_STRING} request.query_parameter ("api") as l_api then
				l_api_resource := l_api.value
				if l_api_resource.is_empty then
					l_api_resource := Void
				end
			end

			if l_api_resource /= Void then
				if doc_url_supported then
					l_description.append ("<a href=%""+ doc_url ("") + "%">Index</a><br/>")
				end
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

			l_description.append ("<div id=%"footer%">")
			if attached footer as l_footer then
				l_description.append (l_footer)
			else
				l_description.append ("-- Self generated documentation --%N")
			end
			l_description.append ("</div>%N")

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
			if doc_url_supported then
				s.append ("<a class=%"mappingresource%" href=%"")
				s.append (doc_url (m.associated_resource))
				s.append ("%">")
				s.append (m.associated_resource)
				s.append ("</a>")
			else
				s.append (m.associated_resource)
			end
			s.append ("</code>")

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

	doc_url_supported: BOOLEAN
			-- Is `doc_url' supported?
		do
			Result := resource /= Void
		end

	doc_url (a_api: STRING_8): STRING_8
			-- URL to show the documentation related to `a_api'.
		require
			doc_url_supported: doc_url_supported
		do
			if attached resource as s then
				Result := request.script_url (s)  + "?api=" + url_encoder.encoded_string (a_api)
			else
				Result := request.script_url ("")
			end
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
