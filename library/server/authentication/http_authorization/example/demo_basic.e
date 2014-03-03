note
	description : "simple application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	DEMO_BASIC

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

	SHARED_HTML_ENCODER

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9090)
			set_service_option ("verbose", True)
		end

feature -- Credentials

	is_known_login (a_login: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_login' a known username?
		do
			Result := valid_credentials.has (a_login)
		end

	is_valid_credential (a_login: READABLE_STRING_GENERAL; a_password: detachable READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_login:a_password' a valid credential?
		do
			if
				a_password /= Void and
				attached valid_credentials.item (a_login) as l_passwd
			then
				Result := a_password.is_case_insensitive_equal (l_passwd)
			end
		ensure
			Result implies is_known_login (a_login)
		end

	demo_credential: STRING_32
			-- First valid known credential display for demo in dialog.
		do
			valid_credentials.start
			create Result.make_from_string_general (valid_credentials.key_for_iteration)
			Result.append_character (':')
			Result.append (valid_credentials.item_for_iteration)
		end

	valid_credentials: STRING_TABLE [READABLE_STRING_32]
			-- Password indexed by login.
		once
			create Result.make_caseless (3)
			Result.force ("world", "eiffel")
			Result.force ("bar", "foo")
			Result.force ("password", "user")
		ensure
			not Result.is_empty
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			auth: HTTP_AUTHORIZATION
		do
			if attached req.http_authorization as l_http_auth then
				create auth.make (l_http_auth)
				if attached auth.login as l_login and then is_valid_credential (l_login, auth.password) then
					handle_authorized (l_login, req, res)
				else
					handle_unauthorized ("ERROR: Invalid credential", req, res)
				end
			else
				handle_unauthorized ("ERROR: Authentication information is missing ...", req, res)
			end
		end

	handle_authorized (a_username: READABLE_STRING_32; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- User `a_username' is authenticated, execute request `req' with response `res'.
		require
			valid_username: not a_username.is_empty
			known_username: is_known_login (a_username)
		local
			s: STRING
			l_logout_url: STRING
		do
			create s.make_empty
			s.append ("Welcome %"")
			s.append (html_encoder.general_encoded_string (a_username))
			s.append ("%" ...<br/>")

			l_logout_url := req.absolute_script_url ("/")
			l_logout_url.replace_substring_all ("://", "://_@") -- Hack to clear http authorization, i.e connect with bad username.
			s.append ("<a href=%""+ l_logout_url +"%">logout</a>")

				-- Append the raw header data for information
			if attached req.raw_header_data as l_header then
				s.append ("<hr/><pre>")
				s.append (l_header)
				s.append ("</pre>")
			end

			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", s.count.out]>>)
			res.put_string (s)
		end

	handle_unauthorized (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Handle forbidden.
		local
			h: HTTP_HEADER
			s: STRING
		do
			create s.make_from_string (a_description)

				-- Append the raw header data for information
			if attached req.raw_header_data as l_header then
				s.append ("<hr/><pre>")
				s.append (l_header)
				s.append ("</pre>")
			end

			create h.make
			h.put_content_type_text_html
			h.put_content_length (s.count)
			h.put_current_date
			h.put_header_key_value ({HTTP_HEADER_NAMES}.header_www_authenticate,
					"Basic realm=%"Please enter a valid username and password (demo [" + html_encoder.encoded_string (demo_credential) + "])%""
					--| warning: for this example: a valid credential is provided in the message, of course that for real application.
				)
			res.set_status_code ({HTTP_STATUS_CODE}.unauthorized)
			res.put_header_text (h.string)
			res.put_string (s)
		end


end
