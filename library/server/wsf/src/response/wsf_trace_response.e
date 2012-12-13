note
	description: "[
			This class is used to respond a TRACE request
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_TRACE_RESPONSE

inherit
	WSF_RESPONSE_MESSAGE

create
	make

feature {NONE} -- Initialization

	make (req: WSF_REQUEST)
		do
			request := req
			create header.make
		end

feature -- Header

	header: HTTP_HEADER
			-- Response' header

	request: WSF_REQUEST
			-- Associated request.

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
		local
			s: STRING
			h: like header
			req: like request
			n, nb: INTEGER
		do
			h := header
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			req := request
			if attached req.raw_header_data as l_header then
				create s.make (l_header.count)
				s.append (l_header.to_string_8)
				s.append_character ('%N')
			else
				s := ""
			end
			if req.is_chunked_input then
				h.put_transfer_encoding_chunked
				res.put_header_text (h.string)
				res.put_chunk (s, Void)
				if attached req.input as l_input then

					from
						n := 1_024
					until
						n = 0
					loop
						s.wipe_out
						nb := l_input.read_to_string (s, 1, n)
						if nb = 0 then
							n := 0
						else
							if nb < n then
								n := 0
							end
							res.put_chunk (s, Void)
						end
					end
				end
				res.put_chunk_end
				res.flush
			else
				req.read_input_data_into (s)
				h.put_content_length (s.count)
				res.put_header_text (h.string)
				res.put_string (s)
				res.flush
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
