note
	description: "Summary description for EWF_URI_PATH."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_MAPPING

inherit
	WSF_ROUTER_MAPPING

create
	make,
	make_trailing_slash_ignored

feature {NONE} -- Initialization

	make (a_uri: READABLE_STRING_8; h: like handler)
		do
			handler := h
			uri := a_uri
		end

	make_trailing_slash_ignored (a_uri: READABLE_STRING_8; h: like handler)
		do
			make (a_uri, h)
			trailing_slash_ignored := True
		end

feature -- Access

	handler: WSF_URI_HANDLER

	uri: READABLE_STRING_8

	trailing_slash_ignored: BOOLEAN

feature -- Status

	routed_handler (req: WSF_REQUEST; res: WSF_RESPONSE; a_router: WSF_ROUTER): detachable WSF_HANDLER
		local
			p: READABLE_STRING_8
			l_uri: like uri
		do
			p := path_from_request (req)
			l_uri := based_uri (uri, a_router)
			if l_uri.ends_with ("/") then
				if not p.ends_with ("/") then
					p := p + "/"
				end
			else
				if p.ends_with ("/") then
					p := p.substring (1, p.count - 1)
				end
			end
			if p.same_string (l_uri) then
				Result := handler
				a_router.execute_before (Current)
				handler.execute (req, res)
				a_router.execute_after (Current)
			end
		end

feature {NONE} -- Implementation

	based_uri (a_uri: like uri; a_router: WSF_ROUTER): like uri
		local
			s: STRING_8
		do
			if attached a_router.base_url as l_base_url then
				create s.make_from_string (l_base_url)
				s.append_string (a_uri)
				Result := s
			else
				Result := a_uri
			end
		end

note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
