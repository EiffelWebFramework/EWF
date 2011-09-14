note
	description: "Summary description for {APP_ACCOUNT_VERIFY_CREDENTIAL}."
	date: "$Date$"
	revision: "$Revision$"

class
	APP_ACCOUNT_VERIFY_CREDENTIAL

inherit
	APP_REQUEST_HANDLER
		redefine
			initialize,
			execute_unauthorized
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			description := "Verify credentials"
			initialize
		end

	initialize
		do
			Precursor
			enable_request_method_get
			enable_format_json
			enable_format_xml
			enable_format_text
		end

feature -- Access

	authentication_required: BOOLEAN = True

feature -- Execution

	execute_unauthorized (a_hdl_context: APP_REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			s: STRING
			lst: LIST [STRING]
		do
			res.set_status_code ({HTTP_STATUS_CODE}.unauthorized)
			res.write_header ({HTTP_STATUS_CODE}.unauthorized, <<["WWW-Authenticate", "Basic realm=%"My Silly demo auth, password must be the same as login such as foo:foo%""]>>)
			res.write_string ("Unauthorized")
		end

	execute_application (ctx: APP_REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		local
			l_full: BOOLEAN
			h: EWF_HEADER
			l_login: STRING_8
			s: STRING
			content_type_supported: ARRAY [STRING]
			l_format_id: INTEGER
		do
			content_type_supported := <<{HTTP_CONSTANTS}.json_app, {HTTP_CONSTANTS}.xml_text, {HTTP_CONSTANTS}.plain_text>>
			l_format_id := ctx.request_format_id ("format", content_type_supported)
			if ctx.authenticated then
				l_full := attached ctx.query_parameter ("details") as v and then v.is_case_insensitive_equal ("true")
				if attached ctx.authenticated_identifier as log then
					l_login := log.as_string_8

					create h.make

					create s.make_empty
					inspect l_format_id
					when {HTTP_FORMAT_CONSTANTS}.json then
						h.put_content_type_text_plain
						s.append_string ("{ %"login%": %"" + l_login + "%" }%N")
					when {HTTP_FORMAT_CONSTANTS}.xml then
						h.put_content_type_text_xml
						s.append_string ("<login>" + l_login + "</login>%N")
					when {HTTP_FORMAT_CONSTANTS}.text then -- Default
						h.put_content_type_text_plain
						s.append_string ("login: " + l_login + "%N")
					else
						execute_content_type_not_allowed (req, res,	content_type_supported,
							<<{HTTP_FORMAT_CONSTANTS}.json_name, {HTTP_FORMAT_CONSTANTS}.html_name, {HTTP_FORMAT_CONSTANTS}.xml_name, {HTTP_FORMAT_CONSTANTS}.text_name>>
						)
					end
					if not s.is_empty then
						res.set_status_code ({HTTP_STATUS_CODE}.ok)
						res.write_headers_string (h.string)
						res.write_string (s)
					end
				else
					send_error (ctx.path, 0, "User/password unknown", Void, ctx, req, res)
				end
			else
				send_error (ctx.path, 0, "Authentication rejected", Void, ctx, req, res)
			end
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
