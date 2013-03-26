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

	proxy_server (req: WSF_REQUEST): URI
			-- Absolute URI of proxy server which `req' must use
		require
			req_attached: req /= Void
			proxy_required: requires_proxy (req)
		deferred
		ensure
			proxy_server_attached: Result /= Void
			valid_uri: Result.is_valid
			absolute_uri: not Result.scheme.is_empty
			http_or_https: Result.scheme.is_case_insensitive_equal ("http") or
				Result.scheme.is_case_insensitive_equal ("https")
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

note
	copyright: "2011-2013, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
