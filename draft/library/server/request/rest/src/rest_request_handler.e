note
	description: "Summary description for {REST_REQUEST_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REST_REQUEST_HANDLER

inherit
	WSF_URI_TEMPLATE_HANDLER

	WSF_HANDLER_HELPER

feature -- Access

	authentication_required (req: WSF_REQUEST): BOOLEAN
			-- Is authentication required
			-- might depend on the request environment
			-- or the associated resources
		deferred
		end

	description: detachable STRING
			-- Optional description		

feature -- Element change

	set_description (s: like description)
			-- Set `description' to `s'
		do
			description := s
		end

feature -- Execution

	execute (ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler	
		do
			if request_method_name_supported (req.request_method) then
				if authentication_required (req) and then not authenticated (ctx) then
					execute_unauthorized (ctx, req, res)
				else
					pre_execute (ctx, req, res)
					execute_application (ctx, req, res)
					post_execute (ctx, req, res)
				end
			else
				execute_request_method_not_allowed (req, res, supported_request_method_names)
			end
		rescue
			execute_rescue (ctx, req, res)
		end

	execute_application (ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		deferred
		end

	pre_execute (ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
		end

	post_execute (ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
		end

	execute_rescue (ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			post_execute (ctx, req, res)
		rescue
			--| Just in case, the rescue is raising other exceptions ...
		end

	execute_unauthorized (ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			res.put_header ({HTTP_STATUS_CODE}.unauthorized, Void)
			res.put_string ("Unauthorized")
		end

feature -- Auth

	authenticated (ctx: REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT): BOOLEAN
			-- Is authenticated?
		do
			--| To redefine if needed
		end

feature {NONE} -- Implementation

	supported_formats: INTEGER
			-- Support request format result such as json, xml, ...

feature {NONE} -- Status report

	format_id_supported (a_id: INTEGER): BOOLEAN
		do
			Result := (supported_formats & a_id) = a_id
		end

	format_name_supported (n: STRING): BOOLEAN
			-- Is format `n' supported?
		do
			Result := format_id_supported (format_constants.format_id (n))
		end

	format_constants: HTTP_FORMAT_CONSTANTS
		once
			create Result
		end

feature -- Status report		

	supported_format_names: LIST [STRING]
			-- Supported format names ...
		do
			create {LINKED_LIST [STRING]} Result.make
			if format_json_supported then
				Result.extend (format_constants.json_name)
			end
			if format_xml_supported then
				Result.extend (format_constants.xml_name)
			end
			if format_text_supported then
				Result.extend (format_constants.text_name)
			end
			if format_html_supported then
				Result.extend (format_constants.html_name)
			end
			if format_rss_supported then
				Result.extend (format_constants.rss_name)
			end
			if format_atom_supported then
				Result.extend (format_constants.atom_name)
			end
		end

	format_json_supported: BOOLEAN
		do
			Result := format_id_supported ({HTTP_FORMAT_CONSTANTS}.json)
		end

	format_xml_supported: BOOLEAN
		do
			Result := format_id_supported ({HTTP_FORMAT_CONSTANTS}.xml)
		end

	format_text_supported: BOOLEAN
		do
			Result := format_id_supported ({HTTP_FORMAT_CONSTANTS}.text)
		end

	format_html_supported: BOOLEAN
		do
			Result := format_id_supported ({HTTP_FORMAT_CONSTANTS}.html)
		end

	format_rss_supported: BOOLEAN
		do
			Result := format_id_supported ({HTTP_FORMAT_CONSTANTS}.rss)
		end

	format_atom_supported: BOOLEAN
		do
			Result := format_id_supported ({HTTP_FORMAT_CONSTANTS}.atom)
		end

feature -- Element change: formats

	reset_supported_formats
		do
			supported_formats := 0
		end

	enable_format_json
		do
			enable_format ({HTTP_FORMAT_CONSTANTS}.json)
		end

	enable_format_xml
		do
			enable_format ({HTTP_FORMAT_CONSTANTS}.xml)
		end

	enable_format_text
		do
			enable_format ({HTTP_FORMAT_CONSTANTS}.text)
		end

	enable_format_html
		do
			enable_format ({HTTP_FORMAT_CONSTANTS}.html)
		end

	enable_format (f: INTEGER)
		do
			supported_formats := supported_formats | f
		end

feature {NONE} -- Implementation

	supported_request_methods: INTEGER
			-- Support request method such as GET, POST, ...

feature {NONE} -- Status report

	request_method_id_supported (a_id: INTEGER): BOOLEAN
		do
			Result := (supported_request_methods & a_id) = a_id
		end

	request_method_name_supported (n: STRING): BOOLEAN
			-- Is request method `n' supported?
		do
			Result := request_method_id_supported (request_method_constants.method_id (n))
		end

	request_method_constants: HTTP_REQUEST_METHOD_CONSTANTS
		once
			create Result
		end

feature -- Status report

	supported_request_method_names: LIST [STRING]
			-- Support request method such as GET, POST, ...
		do
			create {LINKED_LIST [STRING]} Result.make
			if method_get_supported then
				Result.extend (request_method_constants.method_get)
			end
			if method_post_supported then
				Result.extend (request_method_constants.method_post)
			end
			if method_put_supported then
				Result.extend (request_method_constants.method_put)
			end
			if method_patch_supported then
				Result.extend (request_method_constants.method_patch)
			end
			if method_delete_supported then
				Result.extend (request_method_constants.method_delete)
			end
			if method_head_supported then
				Result.extend (request_method_constants.method_head)
			end
		end

	method_get_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.get)
		end

	method_post_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.post)
		end

	method_put_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.put)
		end

	method_patch_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.patch)
		end

	method_delete_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.delete)
		end

	method_head_supported: BOOLEAN
		do
			Result := request_method_id_supported ({HTTP_REQUEST_METHOD_CONSTANTS}.head)
		end

feature -- Element change: request methods		

	reset_supported_request_methods
		do
			supported_request_methods := 0
		end

	enable_request_method_get
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.get)
		end

	enable_request_method_post
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.post)
		end

	enable_request_method_put
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.put)
		end

	enable_request_method_patch
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.patch)
		end

	enable_request_method_delete
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.delete)
		end

	enable_request_method_head
		do
			enable_request_method ({HTTP_REQUEST_METHOD_CONSTANTS}.head)
		end

	enable_request_method (m: INTEGER)
		do
			supported_request_methods := supported_request_methods | m
		end



note
	copyright: "Copyright (c) 1984-2012, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
