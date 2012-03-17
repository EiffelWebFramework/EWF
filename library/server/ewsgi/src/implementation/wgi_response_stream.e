note
	description: "[
			WGI Response implemented using stream buffer

		]"
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_RESPONSE_STREAM

inherit
	WGI_RESPONSE

create
	make

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			output := a_output
		end

feature {WGI_CONNECTOR, WGI_SERVICE} -- Commit

	commit
			-- Commit the current response
		do
			output.flush
			message_committed := True
		end

feature -- Status report

	status_committed: BOOLEAN
			-- Status code set and committed?

	header_committed: BOOLEAN
			-- Header committed?

	message_committed: BOOLEAN
			-- Message committed?

	message_writable: BOOLEAN
			-- Can message be written?
		do
			Result := status_is_set and header_committed
		end

feature {NONE} -- Core output operation

	write (s: READABLE_STRING_8)
			-- Send the content of `s'
			-- this can be used for header and body
		do
			output.put_string (s)
		end

feature -- Status setting

	status_is_set: BOOLEAN
			-- Is status set?
		do
			Result := status_code /= 0
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		do
			status_code := a_code
		end

	status_code: INTEGER
			-- Response status

feature -- Header output operation

	put_header_text (a_text: READABLE_STRING_8)
		do
			write (a_text)
			write (crlf)
			header_committed := True
		end

	put_header_lines (a_lines: ITERABLE [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		local
			h: STRING_8
		do
			create h.make (256)
			across
				a_lines as c
			loop
				h.append (c.item.name)
				h.append_character (':')
				h.append_character (' ')
				h.append (c.item.value)
				h.append_character ('%R')
				h.append_character ('%N')
			end
			put_header_text (h)
		end

feature -- Output operation

	put_string (s: READABLE_STRING_8)
			-- Send the string `s'
		do
			write (s)
		end

	put_substring (s: READABLE_STRING_8; start_index, end_index: INTEGER)
			-- Send the substring `start_index:end_index]'
			--| Could be optimized according to the target output
		do
			output.put_substring (s, start_index, end_index)
		end

	flush
		do
			output.flush
		end

feature {NONE} -- Implementation: Access

	crlf: STRING = "%R%N"
			-- End of header

	output: WGI_OUTPUT_STREAM
			-- Server output channel

;note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
