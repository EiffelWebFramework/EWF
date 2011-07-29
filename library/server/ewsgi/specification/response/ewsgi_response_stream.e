note
	description: "Summary description for {EWSGI_RESPONSE_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EWSGI_RESPONSE_STREAM

feature {EWSGI_APPLICATION} -- Commit

	commit (a_output_stream: EWSGI_OUTPUT_STREAM)
			-- Commit the current response
		deferred
		ensure
			status_set: is_status_set
		end

feature {NONE} -- Core output operation

	write (s: STRING)
			-- Send the string `s'
			-- this can be used for header and body
		deferred
		end

feature -- Status setting

	is_status_set: BOOLEAN
			-- Is status set?
		deferred
		end

	set_status_code (a_code: INTEGER)
			-- Set response status code
			-- Should be done before sending any data back to the client
		require
			status_not_set: not is_status_set
		deferred
		ensure
			status_code_set: status_code = a_code
			status_set: is_status_set
		end

	status_code: INTEGER
			-- Response status
		deferred
		end

feature -- Output operation

	flush
			-- Flush if it makes sense
		deferred
		end

	write_string (s: STRING)
			-- Send the string `s'
		require
			status_set: is_status_set
		deferred
		end

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		require
			status_set: is_status_set
		deferred
		end

feature -- Header output operation

	write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: STRING; value: STRING]])
			-- Send headers with status `a_status', and headers from `a_headers'
		require
			status_not_set: not is_status_set
		deferred
		ensure
			status_set: is_status_set
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
