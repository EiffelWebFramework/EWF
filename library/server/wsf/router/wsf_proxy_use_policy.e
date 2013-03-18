note

	description: "[
						Policies that determine if the client must use a proxy server
						 to access the resource.

						The default policy implemented here is to require
						 use of the proxy for HTTP/1.0 clients (only) for all requests.
						]"
	
	date: "$Date$"
	revision: "$Revision$"

deferred class WSF_PROXY_USE_POLICY

feature -- Access

	requires_proxy (req: WSF_REQUEST): BOOLEAN
			-- Does `req' require use of `proxy_server'?
		require
			req_attached: req /= Void
		do
			if is_http_1_0 (req) then
				Result := True
			end
		end

	proxy_server (req: WSF_REQUEST): READABLE_STRING_8  -- We can't currently use UT_URI
			-- Absolute URI of proxy server which `req' must use
			--| An alternative design would allow a relative URI (relative to the server host),
			--|  which will only work if both the server and the proxy use the default ports.
		require
			req_attached: req /= Void
			proxy_required: requires_proxy (req)
		deferred
		ensure
			absolute_uri: True -- We can't currently use UT_URI to check this. Have we got another class?
		end

	is_http_1_0 (req: WSF_REQUEST): BOOLEAN
			-- Does `req' come from an HTTP/1.0 client?
		require
			req_attached: req /= Void
		local
			l_protocol: READABLE_STRING_8
			l_tokens: LIST [READABLE_STRING_8]
			l_protocol_name, l_protocol_version, l_major, l_minor: STRING_8
		do
			l_protocol := req.server_protocol
			l_tokens := l_protocol.split ('/')
			if l_tokens.count = 2 then
				l_protocol_name := l_tokens [1].as_string_8
				l_protocol_name.left_adjust
				l_protocol_name.right_adjust
				if l_protocol_name.is_case_insensitive_equal ({HTTP_CONSTANTS}.http_version_1_0.substring (1, 4)) then
					l_protocol_version := l_tokens [2].as_string_8
					l_protocol_version.left_adjust
					l_protocol_version.right_adjust
					l_tokens := l_protocol_version.split ('.')
					if l_tokens.count = 2 then
						l_major := l_tokens [1].as_string_8
						l_major.left_adjust
						l_major.right_adjust
						l_minor := l_tokens [2].as_string_8
						l_minor.left_adjust
						l_minor.right_adjust
						if l_major.is_integer and then l_major.to_integer = 1 and then
							l_minor.is_integer and then l_minor.to_integer = 0 then
							Result := True
						end
					end
				end
			end
		end

end
