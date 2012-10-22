note
	description: "[
				Main interface to send message back to the client
				
				You can send part by part, i.e:
				- set the status code, see: set_status_code (a_code)
				- put the header's text, see: put_header_text (a_text)
				- put string for the body, see: put_string (s), put_character (c)
				- using put_error will eventually send error message directly to the underlying connector's log
				  (i.e for apache, it will go to the error log)
				- And you can also send the message as "chunked", see put_chunk (..) for more details
				- Or you can send a WSF_RESPONSE_MESSAGE in once, see `send (mesg)'
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_RESPONSE

create {WSF_TO_WGI_SERVICE}
	make_from_wgi

convert
	make_from_wgi ({WGI_RESPONSE})

feature {NONE} -- Initialization

	make_from_wgi (r: WGI_RESPONSE)
		do
			transfered_content_length := 0
			wgi_response := r
		end

	wgi_response: WGI_RESPONSE
			-- Associated WGI_RESPONSE

feature -- Status report

	status_committed: BOOLEAN
			-- Status line committed?
		do
			Result := wgi_response.status_committed
		end

	header_committed: BOOLEAN
			-- Header committed?
		do
			Result := wgi_response.header_committed
		end

	message_committed: BOOLEAN
			-- Message committed?
		do
			Result := wgi_response.message_committed
		end

	message_writable: BOOLEAN
			-- Can message be written?
		do
			Result := wgi_response.message_writable
		end

feature -- Status setting

	status_is_set: BOOLEAN
			-- Is status set?
		do
			Result := status_code > 0
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
			--| note: the status is really sent when the header are set
		require
			a_code_valid: a_code > 0
			status_not_set: not status_committed
			header_not_committed: not header_committed
		do
			status_code := a_code
			status_reason_phrase := Void
		ensure
			status_code_set: status_code = a_code
			status_set: status_is_set
			status_reason_phrase_unset: status_reason_phrase = Void
		end

	set_status_code_with_reason_phrase (a_code: INTEGER; a_reason_phrase: READABLE_STRING_8)
			-- Set response status code
			-- Should be done before sending any data back to the client
			--| note: the status is really sent when the header are set			
		require
			a_code_valid: a_code > 0
			status_not_set: not status_committed
			header_not_committed: not header_committed
		do
			set_status_code (a_code)
			status_reason_phrase := a_reason_phrase
		ensure
			status_code_set: status_code = a_code
			status_reason_phrase_set: status_reason_phrase = a_reason_phrase
			status_set: status_is_set
		end

	status_code: INTEGER
			-- Response status

	status_reason_phrase: detachable READABLE_STRING_8
			-- Custom status reason phrase (optional)

feature -- Header output operation

	put_header_text (a_text: READABLE_STRING_8)
			-- Sent `a_text' and just before send the status code
		require
			status_set: status_is_set
			header_not_committed: not header_committed
			a_text_ends_with_single_crlf: a_text.count > 2 implies not a_text.substring (a_text.count - 2, a_text.count).same_string ("%R%N")
			a_text_does_not_end_with_double_crlf: a_text.count > 4 implies not a_text.substring (a_text.count - 4, a_text.count).same_string ("%R%N%R%N")
		do
			wgi_response.set_status_code (status_code, status_reason_phrase)
			wgi_response.put_header_text (a_text)
		ensure
			status_set: status_is_set
			status_committed: status_committed
			header_committed: header_committed
			message_writable: message_writable
		end

	put_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Send headers with status `a_status', and headers from `a_headers'
		require
			status_not_committed: not status_committed
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
		do
			set_status_code (a_status_code)
			if a_headers /= Void then
				create h.make_from_array (a_headers)
				put_header_text (h.string)
			end
		ensure
			status_set: status_is_set
			header_committed: header_committed
			message_writable: message_writable
		end

	put_header_lines (a_lines: ITERABLE [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Send headers from `a_lines'
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

feature -- Output report

	transfered_content_length: NATURAL_64
			-- Length of the content transfered via `put_string', `put_character'
			-- `put_chunk', `put_substring'

feature {NONE} -- Implementation

	increment_transfered_content_length (n: INTEGER)
			-- Increment `transfered_content_length' by `n'
		do
			transfered_content_length := transfered_content_length + n.to_natural_64
		end

feature -- Output operation

	put_character (c: CHARACTER_8)
			-- Send the character `c'
		require
			message_writable: message_writable
		do
			wgi_response.put_character (c)
			increment_transfered_content_length (1)
		end

	put_string (s: READABLE_STRING_8)
			-- Send the string `s'
		require
			message_writable: message_writable
		do
			wgi_response.put_string (s)
			increment_transfered_content_length (s.count)
		end

	put_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
			-- Send the substring `s[a_begin_index:a_end_index]'
		require
			message_writable: message_writable
		do
			wgi_response.put_substring (s, a_begin_index, a_end_index)
			increment_transfered_content_length (a_end_index - a_begin_index + 1)
		end

	put_chunk (s: READABLE_STRING_8; a_extension: detachable READABLE_STRING_8)
			-- Write chunk non empty `s'
			-- Note: that you should have header
			-- "Transfer-Encoding: chunked"
		require
			s_not_empty: s /= Void and then not s.is_empty
			message_writable: message_writable
			valid_chunk_extension: a_extension /= Void implies not a_extension.has ('%N') and not not a_extension.has ('%R')
		local
			l_chunk_size_line: STRING_8
			i: INTEGER
		do
			if s.is_empty then
					-- Should not occur due to precondition,
					-- but let's handle the case for backward compatibility reason.
				put_chunk_end
			else
					--| Remove all left '0'
				l_chunk_size_line := s.count.to_hex_string
				from
					i := 1
				until
					l_chunk_size_line[i] /= '0'
				loop
					i := i + 1
				end
				if i > 1 then
					l_chunk_size_line := l_chunk_size_line.substring (i, l_chunk_size_line.count)
				end

				if a_extension /= Void then
					l_chunk_size_line.append_character (';')
					l_chunk_size_line.append (a_extension)
				end
				l_chunk_size_line.append ({HTTP_CONSTANTS}.crlf)
				put_string (l_chunk_size_line)
				put_string (s)
				put_string ({HTTP_CONSTANTS}.crlf)
				flush
				increment_transfered_content_length (s.count)
			end
		end

	put_chunk_end
			-- Put end of chunked content
		do
			put_string ("0" + {HTTP_CONSTANTS}.crlf)
			flush
		end

	flush
			-- Flush if it makes sense
		do
			wgi_response.flush
		end

feature -- Response object

	send (a_message: WSF_RESPONSE_MESSAGE)
			-- Set `a_message' as the whole response to the client
			--| `a_message' is responsible to sent the status code, the header and the content
		require
			header_not_committed: not header_committed
			status_not_committed: not status_committed
			no_message_committed: not message_committed
		do
			a_message.send_to (Current)
		ensure
			status_committed: status_committed
			header_committed: header_committed
		end

feature -- Redirect

	redirect_now_custom (a_url: READABLE_STRING_8; a_status_code: INTEGER; a_header: detachable HTTP_HEADER; a_content: detachable TUPLE [body: READABLE_STRING_8; type: READABLE_STRING_8])
			-- Redirect to the given url `a_url' and precise custom `a_status_code', custom header and content
			-- Please see http://www.faqs.org/rfcs/rfc2616 to use proper status code.
			-- if `a_status_code' is 0, use the default {HTTP_STATUS_CODE}.temp_redirect
		require
			header_not_committed: not header_committed
		local
			h: HTTP_HEADER
			b: READABLE_STRING_8
		do
			if header_committed then
				-- This might be a trouble about content-length				
				put_string ("Headers already sent.%NCannot redirect, for now please follow this <a %"href=%"" + a_url + "%">link</a> instead%N")
			else
				if a_header /= Void then
					create h.make_from_header (a_header)
				else
					create h.make_with_count (1)
				end
				h.put_location (a_url)
				if a_status_code = 0 then
					if not status_is_set then
						set_status_code ({HTTP_STATUS_CODE}.temp_redirect)
					end
				else
					set_status_code (a_status_code)
				end
				if a_content /= Void then
					b := a_content.body
					h.put_content_length (b.count)
					h.put_content_type (a_content.type)
					put_header_text (h.string)
					put_string (b)
				else
					h.put_content_length (0)
					put_header_text (h.string)
				end
			end
		end

	redirect_now (a_url: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		require
			header_not_committed: not header_committed
		do
			redirect_now_custom (a_url, {HTTP_STATUS_CODE}.found, Void, Void)
		end

	redirect_now_with_content (a_url: READABLE_STRING_8; a_content: READABLE_STRING_8; a_content_type: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		do
			redirect_now_custom (a_url, {HTTP_STATUS_CODE}.found, Void, [a_content, a_content_type])
		end

feature -- Error reporting

	put_error (a_message: READABLE_STRING_8)
			-- Report error described by `a_message'
			-- This might be used by the underlying connector
		do
			wgi_response.put_error (a_message)
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
