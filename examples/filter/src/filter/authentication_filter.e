note
	description: "Authentication filter."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	AUTHENTICATION_FILTER

inherit
	WSF_FILTER_URI_TEMPLATE_HANDLER

	SHARED_DATABASE_API

	WSF_RESOURCE_HANDLER_HELPER
--		redefine
--			do_get
--		end

	SHARED_DATABASE_API

	SHARED_EJSON

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter
		local
			l_auth: HTTP_AUTHORIZATION
		do
			create l_auth.make (req.http_authorization)
			if (attached l_auth.type as l_auth_type and then l_auth_type.is_equal ("basic")) and
				attached Db_access.users.item (1) as l_user and then
				(attached l_auth.login as l_auth_login and then l_auth_login.is_equal (l_user.name)
				and attached l_auth.password as l_auth_password and then l_auth_password.is_equal (l_user.password)) then
				execute_next (req, res)
			else
				handle_unauthorized ("Unauthorized", req, res)
			end
		end

feature {NONE} -- Implementation

	handle_unauthorized (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Handle forbidden.
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_plain
			h.put_content_length (a_description.count)
			h.put_current_date
			h.put_header_key_value ({HTTP_HEADER_NAMES}.header_www_authenticate, "Basic realm=%"User%"")
			res.set_status_code ({HTTP_STATUS_CODE}.unauthorized)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end

end
