note
	description: "Summary description for EWF_URI_PATH."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STARTS_WITH_MAPPING

inherit
	WSF_ROUTER_MAPPING

create
	make

feature {NONE} -- Initialization

	make (a_uri: READABLE_STRING_8; h: like handler)
		do
			handler := h
			uri := a_uri
		end

feature -- Access

	handler: WSF_STARTS_WITH_HANDLER

	uri: READABLE_STRING_8

feature -- Status

	routed_handler (req: WSF_REQUEST; res: WSF_RESPONSE; a_router: WSF_ROUTER): detachable WSF_HANDLER
		local
			p: READABLE_STRING_8
			s: like based_uri
		do
			p := source_uri (req)
			s := based_uri (uri, a_router)
			if p.starts_with (s) then
				Result := handler
				a_router.execute_before (Current)
				handler.execute (s, req, res)
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

end
