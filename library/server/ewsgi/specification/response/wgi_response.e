note
	description: "Summary description for {WGI_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_RESPONSE

feature {WGI_CONNECTOR, WGI_SERVICE} -- Commit

	commit
			-- Commit the current response
		deferred
		ensure
			status_is_set: status_is_set
			header_committed: header_committed
			message_committed: message_committed
		end

feature -- Status report

	status_committed: BOOLEAN
			-- Is status code set and committed?
			-- i.e: sent to the client and could not be changed anymore
		deferred
		ensure
			committed_implies_set: Result implies status_is_set
		end

	header_committed: BOOLEAN
			-- Header committed?
		deferred
		end

	message_committed: BOOLEAN
			-- Message committed?
		deferred
		end

	message_writable: BOOLEAN
			-- Can message be written?
		deferred
		end

feature -- Status setting

	status_is_set: BOOLEAN
			-- Is status set?
		deferred
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		require
			status_not_set: not status_committed
			header_not_committed: not header_committed
		deferred
		ensure
			status_code_set: status_code = a_code
			status_set: status_is_set
		end

	status_code: INTEGER
			-- Response status
		deferred
		end

feature -- Header output operation

	put_header_text (a_text: READABLE_STRING_8)
			-- Write http header string `a_text'
			-- It should not contain the ending CR LF CR LF
			-- since it is the duty of `put_header_text' to write it.
		require
			a_text_does_not_has_ending_crlf_crlf: a_text.count > 4 implies not a_text.substring (a_text.count - 4, a_text.count).same_string ("%R%N%R%N")
			status_set: status_is_set
			header_not_committed: not header_committed
		deferred
		ensure
			status_set: status_is_set
			header_committed: header_committed
			message_writable: message_writable
		end

	put_header_lines (a_lines: ITERABLE [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		require
			status_set: status_is_set
			header_not_committed: not header_committed
		deferred
		ensure
			status_set: status_is_set
			header_committed: header_committed
			message_writable: message_writable
		end

feature -- Output operation

	put_character (c: CHARACTER_8)
			-- Send the character `c'
		require
			message_writable: message_writable
		deferred
		end

	put_string (s: READABLE_STRING_8)
			-- Send the string `s'
		require
			message_writable: message_writable
		deferred
		end

	put_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
			-- Send the substring `s[a_begin_index:a_end_index]'
		require
			message_writable: message_writable
		deferred
		end

	flush
			-- Flush if it makes sense
		deferred
		end

feature -- Error reporting

	put_error (a_message: READABLE_STRING_8)
			-- Report error described by `a_message'
			-- This might be used by the underlying connector
		deferred
		end

note
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
