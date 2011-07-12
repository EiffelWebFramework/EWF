note
	description: "Summary description for {GW_NINO_INPUT_STREAM}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_NINO_INPUT_STREAM

inherit
	GW_INPUT_STREAM

create
	make

feature {NONE} -- Initialization

	make (a_nino_input: like nino_input)
		do
			create last_string.make_empty
			set_nino_input (a_nino_input)
		end

feature {GW_NINO_CONNECTOR, GW_APPLICATION} -- Nino

	set_nino_input (i: like nino_input)
		do
			nino_input := i
		end

	nino_input: HTTP_INPUT_STREAM

feature -- Basic operation

	read_stream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of file.
			-- Make result available in `last_string'.	
		do
			nino_input.read_stream (nb_char)
			last_string := nino_input.last_string
		end

feature -- Access		

	last_string: STRING
			-- Last string read	

;note
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
