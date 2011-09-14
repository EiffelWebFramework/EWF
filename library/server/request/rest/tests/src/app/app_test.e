note
	description: "Summary description for {APP_TEST}."
	date: "$Date$"
	revision: "$Revision$"

class
	APP_TEST

inherit
	APP_REQUEST_HANDLER
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			description := "Return a simple test output "
			initialize
		end

	initialize
		do
			Precursor
			enable_request_method_get
			enable_format_text
		end

feature -- Access

	authentication_required: BOOLEAN = False

feature -- Execution

	execute_application (ctx: APP_REQUEST_HANDLER_CONTEXT; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute request handler
		local
			s: STRING
			h: EWF_HEADER
		do
			create h.make
			h.put_content_type_text_plain

			create s.make_empty
			s.append_string ("test")
			if attached req.meta_variable ("REQUEST_COUNT") as l_request_count_val then
				s.append_string ("(request_count="+ l_request_count_val.as_string +")%N")
			end

--			ctx.request_format_id ("format", Void)

			if attached ctx.request_format ("format", Void) as l_format then
				s.append_string (" format=" + l_format + "%N")
			end

			if attached ctx.string_parameter ("op") as l_op then
				s.append_string (" op=" + l_op)
				if l_op.same_string ("crash") then
					(create {DEVELOPER_EXCEPTION}).raise
				elseif l_op.starts_with ("env") then
					s.append_string ("%N%NAll variables:")
					s.append (wgi_value_iteration_to_string (req.parameters, False))
					s.append_string ("<br/>script_url(%"" + req.path_info + "%")=" + ctx.script_url (req.path_info) + "%N")
--					if attached ctx.http_authorization_login_password as t then
--						s.append_string ("Check login=" + t.login + "<br/>%N")
--					end
					if ctx.authenticated and then attached ctx.authenticated_identifier as l_login then
						s.append_string ("Authenticated: login=" + l_login.as_string_8 + "<br/>%N")
					end
				end
			else
				s.append ("%N Try " + ctx.script_absolute_url (req.path_info + "?op=env") + " to display all variables%N")
				s.append ("%N Try " + ctx.script_absolute_url (req.path_info + "?op=crash") + " to demonstrate exception trace%N")
			end

			res.set_status_code (200)
			res.write_headers_string (h.string)
			res.write_string (s)
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
