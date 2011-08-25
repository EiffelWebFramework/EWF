note
	description: "Summary description for GW_CGI_INPUT_STREAM."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_CGI_INPUT_STREAM

inherit
	EWSGI_INPUT_STREAM

	CONSOLE
		rename
			make as console_make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_open_stdin ("stdin")
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
