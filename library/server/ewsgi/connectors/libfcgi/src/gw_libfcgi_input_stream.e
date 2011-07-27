note
	description: "Summary description for GW_LIBFCGI_INPUT_STREAM."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_LIBFCGI_INPUT_STREAM

inherit
	EWSGI_INPUT_STREAM

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_fcgi: like fcgi)
		require
			valid_fcgi: a_fcgi /= Void
		do
			fcgi := a_fcgi
			initialize
		end

	initialize
			-- Initialize Current
		do
			create last_string.make_empty
		end

feature -- Basic operation

	read_stream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of file.
			-- Make result available in `last_string'.	
		do
			fcgi.fill_string_from_stdin (last_string, nb_char)
		end

feature -- Access		

	last_string: STRING
			-- Last string read	

feature {NONE} -- Implementation

	fcgi: FCGI;
			-- Bridge to FCGI world

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
