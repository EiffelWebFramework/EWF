note
	description: "Summary description for {GW_LIBFCGI_OUTPUT_STREAM}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_LIBFCGI_OUTPUT_STREAM

inherit
	GW_OUTPUT_STREAM

create
	make

feature {NONE} -- Initialization

	make (a_fcgi: like fcgi)
		require
			valid_fcgi: a_fcgi /= Void
		do
			fcgi := a_fcgi
		end

feature -- Basic operation

	put_string (s: STRING)
			-- Send `s' to http client
		do
			fcgi.put_string (s)
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
