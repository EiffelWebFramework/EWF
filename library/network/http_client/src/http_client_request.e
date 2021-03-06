note
	description: "[
				Object representing a http client request
				It is mainly used internally by the HTTP_CLIENT_SESSION
			]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTP_CLIENT_REQUEST

inherit
	REFACTORING_HELPER

feature {NONE} -- Initialization

	make (a_url: READABLE_STRING_8; a_request_method: like request_method; a_session: like session; ctx: like context)
			-- Initialize `Current' with request url `a_url', method `a_request_method' within the session `a_session'
			-- and optional context `ctx' which can be used to pass additional parameters.
		do
			request_method := a_request_method
			session := a_session
			initialize (a_url, ctx)
		ensure
			context_set: context = ctx
			ctx_header_set: ctx /= Void implies across ctx.headers as ctx_h all attached headers.item (ctx_h.key) as v and then v.same_string (ctx_h.item) end
		end

	initialize (a_url: READABLE_STRING_8; ctx: like context)
			-- Initialize Current with `a_url' and `ctx'.
			-- This can be used to reset/reinitialize Current with new url
			-- in the case of redirection.
		local
			i: INTEGER
		do
			i := a_url.substring_index ("://", 1)
			if i > 0 then
				check
					a_url.head (i - 1).same_string ("http")
					or a_url.head (i - 1).same_string ("https")
				end
				url := a_url
			else
				url := session.url (a_url, Void)
			end
			headers := session.headers.twin
			if ctx /= Void then
				context := ctx
				import (ctx)
			else
				context := Void
			end
		end

feature {NONE} -- Internal		

	session: HTTP_CLIENT_SESSION
			-- Session related to Current request.
			-- It provides a few parameters related to session.

	context: detachable HTTP_CLIENT_REQUEST_CONTEXT
			-- Potential additional parameters for this specific request.

feature -- Status report

	is_debug: BOOLEAN
			-- Debug mode enabled?
		do
			Result := session.is_debug
		end

feature -- Access

	request_method: READABLE_STRING_8
			-- Request method associated with Current request.

	url: READABLE_STRING_8
			-- URL associated with current request.

	headers: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]
			-- Specific headers to be used for current request.

	response: HTTP_CLIENT_RESPONSE
			-- Response received from request execution.
			-- Check `error_occurred' for eventual error.
			-- note: two consecutive calls will trigger two executions!
		deferred
		ensure
			Result_set: Result /= Void
		end

feature {HTTP_CLIENT_SESSION} -- Execution

	import (ctx: HTTP_CLIENT_REQUEST_CONTEXT)
			-- Import `ctx' parameters.
		local
			l_headers: like headers
		do
			l_headers := headers
			across
				ctx.headers as ctx_headers
			loop
					--| fill header from `ctx'
					--| and use `force' to overwrite the "session" value if any
				l_headers.force (ctx_headers.item, ctx_headers.key)
			end
		end

feature -- Authentication

	auth_type: READABLE_STRING_8	
    		-- Set the authentication type for the request.
			-- Types: "basic", "digest", "any"
		do
			Result := session.auth_type
		end

	auth_type_id: INTEGER
    		-- Set the authentication type for the request.
			-- Types: "basic", "digest", "any"
		do
			Result := session.auth_type_id
		end

	username: detachable READABLE_STRING_32
			-- Username specified for the `session'.
		do
			Result := session.username
		end

	password: detachable READABLE_STRING_32
			-- Password specified for the `session'.
		do
			Result := session.password
		end

	credentials: detachable READABLE_STRING_32
			-- Credentials specified for the `session'.
			--| Usually `username':`password'
		do
			Result := session.credentials
		end

	proxy: detachable TUPLE [host: READABLE_STRING_8; port: INTEGER]
			-- Optional proxy settings.
		do
			Result := session.proxy
		end

feature -- Settings

	timeout: INTEGER
			-- HTTP transaction timeout in seconds.
			--| 0 means it never timeouts
		do
			Result := session.timeout
		end

	connect_timeout: INTEGER
			-- HTTP connection timeout in milliseconds.
			--| 0 means it never timeouts
		do
			Result := session.connect_timeout
		end

	max_redirects: INTEGER
    		-- Maximum number of times to follow redirects.
		do
			Result := session.max_redirects
		end

	ignore_content_length: BOOLEAN
			-- Does this session ignore Content-Size headers?
		do
			Result := session.ignore_content_length
		end

	buffer_size: INTEGER
			-- Buffer size for request,
			-- initialized from the session buffer_size value, or default 2_048.
		do
			Result := session.buffer_size.to_integer_32
			if Result <= 0 then
				Result := 2_048
			end
		end

	chunk_size: INTEGER
			-- Chunk size for request, when "Transfer-Encoding: chunked"
			-- initialized from the session buffer_size value, or default 2_048.
		do
			Result := session.chunk_size.to_integer_32
			if Result <= 0 then
				Result := 2_048
			end
		end

	default_response_charset: detachable READABLE_STRING_8
			-- Default encoding of responses. Used if no charset is provided by the host.
		do
			Result := session.default_response_charset
		end

	is_insecure: BOOLEAN
			-- Allow connections to SSL sites without certs	
		do
			Result := session.is_insecure
		end

note
	copyright: "2011-2018, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
