note
	description : "Objects that represent a custom error"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_CUSTOM

inherit
	ERROR

create
	make

feature {NONE} -- Initialization

	make (a_code: INTEGER; a_name: STRING; a_message: detachable like message)
			-- Initialize `Current'.
		do
			code := a_code
			name := a_name
			if attached a_message then
				message := a_message
			else
				message := "Error: " + a_name + " (code=" + a_code.out + ")"
			end
		end

feature -- Access

	code: INTEGER

	name: STRING

	message: STRING_32

feature -- Visitor

	process (a_visitor: ERROR_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_custom (Current)
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
