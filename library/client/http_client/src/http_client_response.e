note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HTTP_CLIENT_RESPONSE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
				--| Default values
			status := 200
			create {STRING_8} raw_header.make_empty
		end

feature -- Status

	error_occurred: BOOLEAN
			-- Error occurred during request

feature {HTTP_CLIENT_REQUEST} -- Status setting

	set_error_occurred (b: BOOLEAN)
			-- Set `error_occurred' to `b'
		do
			error_occurred := b
		end

feature -- Access

	status: INTEGER assign set_status
			-- Status code of the response.

	raw_header: READABLE_STRING_8
			-- Raw http header of the response.	

	headers: LIST [TUPLE [key: READABLE_STRING_8; value: READABLE_STRING_8]]
			-- Computed table of http headers of the response.
		local
			tb: like internal_headers
			pos, l_start, l_end, n, c: INTEGER
			h: like raw_header
			k: STRING_8
		do
			tb := internal_headers
			if tb = Void then
				create tb.make (3)
				h := raw_header
				from
					pos := 1
					n := h.count
				until
					pos = 0 or pos > n
				loop
					l_start := pos
						--| Left justify
					from until not h[l_start].is_space loop
						l_start := l_start + 1
					end
					pos := h.index_of ('%N', l_start)
					if pos > 0 then
						l_end := pos - 1
					elseif l_start < n then
						l_end := n + 1
					else
							-- Empty line
						l_end := 0
					end
					if l_end > 0 then
							--| Right justify
						from until not h[l_end].is_space loop
							l_end := l_end - 1
						end
						c := h.index_of (':', l_start)
						if c > 0 then
							k := h.substring (l_start, c - 1)
							k.right_adjust
							c := c + 1
							from until c <= n and not h[c].is_space loop
								c := c + 1
							end
							tb.force ([k, h.substring (c, l_end)])
						else
							check header_has_colon: c > 0 end
						end
					end
					pos := pos + 1
				end
				internal_headers := tb
			end
			Result := tb
		end

	body: detachable READABLE_STRING_8 assign set_body
			-- Content of the response

feature -- Change

	set_status (s: INTEGER)
			-- Set response `status' code to `s'
		do
			status := s
		end

	set_raw_header (h: READABLE_STRING_8)
			-- Set http header `raw_header' to `h'
		do
			raw_header := h
				--| Reset internal headers
			internal_headers := Void
		end

	set_body (s: like body)
			-- Set `body' message to `s'
		do
			body := s
		end

feature {NONE} -- Implementation

	internal_headers: detachable ARRAYED_LIST [TUPLE [key: READABLE_STRING_8; value: READABLE_STRING_8]]
			-- Internal cached value for the headers

end
