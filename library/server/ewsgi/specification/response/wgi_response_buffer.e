note
	description: "Summary description for {WGI_RESPONSE_BUFFER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_RESPONSE_BUFFER

feature {WGI_APPLICATION} -- Commit

	commit
			-- Commit the current response
		deferred
		ensure
			status_is_set: status_is_set
			header_committed: header_committed
			message_committed: message_committed
		end

feature -- Status report

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

feature {WGI_RESPONSE_BUFFER} -- Core output operation

	write (s: READABLE_STRING_8)
			-- Send the string `s'
			-- this can be used for header and body
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
			status_not_set: not status_is_set
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

	write_headers_string (a_headers: READABLE_STRING_8)
		require
			status_set: status_is_set
			header_not_committed: not header_committed
		deferred
		ensure
			status_set: status_is_set
			header_committed: header_committed
			message_writable: message_writable
		end

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Send headers with status `a_status', and headers from `a_headers'
		require
			status_not_set: not status_is_set
			header_not_committed: not header_committed
		deferred
		ensure
			header_committed: header_committed
			status_set: status_is_set
			message_writable: message_writable
		end

feature -- Output operation

	write_string (s: READABLE_STRING_8)
			-- Send the string `s'
		require
			message_writable: message_writable
		deferred
		end

	write_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
			-- Send the substring `s[a_begin_index:a_end_index]'
		require
			message_writable: message_writable
		deferred
		end

	write_file_content (fn: READABLE_STRING_8)
			-- Send the content of file `fn'
		require
			message_writable: message_writable
		deferred
		end

	flush
			-- Flush if it makes sense
		deferred
		end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
