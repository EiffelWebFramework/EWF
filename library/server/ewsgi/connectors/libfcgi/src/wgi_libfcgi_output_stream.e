note
	description: "Summary description for {WGI_LIBFCGI_OUTPUT_STREAM}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_LIBFCGI_OUTPUT_STREAM

inherit
	WGI_OUTPUT_STREAM

	HTTP_STATUS_CODE_MESSAGES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_fcgi: like fcgi)
		require
			valid_fcgi: a_fcgi /= Void
		do
			fcgi := a_fcgi
		end

feature -- Status report

	is_open_write: BOOLEAN
			-- Can items be written to output stream?
		do
			Result := True
		end

feature -- Status writing

	put_status_line (a_code: INTEGER)
			-- Put status code line for `a_code'
			--| Note this is a default implementation, and could be redefined
			--| for instance in relation to NPH CGI script
		do
			--| Do not send any Status line back to the FastCGI client
		end

feature -- Basic operation

	put_string (s: READABLE_STRING_8)
			-- Send `s' to http client
		do
			fcgi.put_string (s)
		end

feature -- Basic operations

	flush
			-- Flush buffered data to disk.
		do
		end

feature {NONE} -- Implementation

	fcgi: FCGI
			-- Bridge to FCGI world

invariant
	fcgi_attached: fcgi /= Void

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
