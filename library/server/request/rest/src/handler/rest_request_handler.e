note
	description: "Summary description for {REST_REQUEST_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REST_REQUEST_HANDLER [C -> REST_REQUEST_HANDLER_CONTEXT]

inherit
	REQUEST_HANDLER [C]
		redefine
			execute
		end

feature -- Access

	authentication_required: BOOLEAN
			-- Is authentication required
			-- might depend on the request environment
			-- or the associated resources
		deferred
		end

feature -- Execution

	execute (a_hdl_context: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute request handler	
		do
			if authentication_required and then not a_hdl_context.authenticated then
				execute_unauthorized (a_hdl_context, req, res)
			else
				Precursor (a_hdl_context, req, res)
			end
		end

	execute_unauthorized (a_hdl_context: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			res.set_status_code ({HTTP_STATUS_CODE}.unauthorized)
			res.write_header ({HTTP_STATUS_CODE}.unauthorized, <<["WWW-Authenticate", "Basic realm=%"Eiffel auth%""]>>)
			res.write_string ("Unauthorized")
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
