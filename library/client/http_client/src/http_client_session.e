note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	HTTP_CLIENT_SESSION

feature {NONE} -- Initialization

	make (a_base_url: READABLE_STRING_8)
			-- Initialize `Current'.
		do
			set_defaults
			create headers.make (3)

			base_url := a_base_url
			initialize
		end

	set_defaults
		do
			timeout := 5
			connect_timeout := 1
			max_redirects := 5
			set_basic_auth_type
		end

	initialize
		deferred
		end

feature -- Basic operation

	get (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		deferred
		end

	head (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		deferred
		end

	post (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		deferred
		end

	put (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		deferred
		end

	delete (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		deferred
		end

feature -- Settings

	timeout: INTEGER
			-- HTTP transaction timeout in seconds. Defaults to 5 seconds.


	connect_timeout: INTEGER
			-- HTTP connection timeout in seconds. Defaults to 1 second.

	max_redirects: INTEGER
    		-- Maximum number of times to follow redirects.
			-- Set to 0 to disable and -1 to follow all redirects. Defaults to 5.

	ignore_content_length: BOOLEAN
			-- Does this session ignore Content-Size headers?

	buffer_size: NATURAL
			-- Set the buffer size for request. This option will
			-- only be set if buffer_size is positive

	default_response_charset: detachable READABLE_STRING_8
			-- Default encoding of responses. Used if no charset is provided by the host.

feature -- Access

	base_url: READABLE_STRING_8

	headers: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]

feature -- Authentication

	auth_type: STRING
    		-- Set the authentication type for the request.
			-- Types: "basic", "digest", "any"

	auth_type_id: INTEGER
			-- See {HTTP_CLIENT_CONSTANTS}.Auth_type_*

	username,
	password: detachable READABLE_STRING_8

	credentials: detachable READABLE_STRING_8

feature -- Change

	set_timeout (n: like timeout)
		do
			timeout := n
		end

	set_user_agent (v: READABLE_STRING_8)
		do
			add_header ("User-Agent", v)
		end

	add_header (k: READABLE_STRING_8; v: READABLE_STRING_8)
		do
			headers.force (v, k)
		end

	set_credentials (u: like username; p: like password)
		do
			username := u
			password := p
			if u /= Void and p /= Void then
				credentials := u + ":" + p
			else
				credentials := Void
			end
		end

	set_auth_type (s: READABLE_STRING_8)
		do
			auth_type := s
			auth_type_id := http_client_constants.auth_type_id (s)
		end

	set_basic_auth_type
		do
			auth_type := "basic"
			auth_type_id := {HTTP_CLIENT_CONSTANTS}.auth_type_basic
		end

	set_digest_auth_type
		do
			auth_type := "digest"
			auth_type_id := {HTTP_CLIENT_CONSTANTS}.auth_type_digest
		end

	set_any_auth_type
		do
			auth_type := "any"
			auth_type_id := {HTTP_CLIENT_CONSTANTS}.auth_type_any
		end

	set_anysafe_auth_type
		do
			auth_type := "anysafe"
			auth_type_id := {HTTP_CLIENT_CONSTANTS}.auth_type_anysafe
		end

feature {NONE} -- Implementation

	http_client_constants: HTTP_CLIENT_CONSTANTS
		once
			create Result
		end
end
