note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HTTP_AUTHORIZATION

create
	make

feature {NONE} -- Initialization

	make (a_http_authorization: detachable READABLE_STRING_GENERAL)
			-- Initialize `Current'.
		local
			p: INTEGER
			s: STRING_8
		do
			if attached a_http_authorization as l_auth then
				s := l_auth.as_string_8
				if not s.is_empty then
					p := 1
					if s[p] = ' ' then
						p := p + 1
					end
					p := s.index_of (' ', p)
					if p > 0 then
						s := (create {BASE64}).decoded_string (s.substring (p + 1, s.count))
						p := s.index_of (':', 1) --| Let's assume ':' is forbidden in login ...
						if p > 0 then
							login := s.substring (1, p - 1).as_string_32
							password := s.substring (p + 1, s.count).as_string_32
						end
					end
				end
			end
		end

feature -- Access

	login: detachable READABLE_STRING_32

	password: detachable READABLE_STRING_32


end
