note
	description: "Summary description for {GW_EXECUTION_VARIABLES}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_EXECUTION_VARIABLES

inherit
	EWSGI_VARIABLES [STRING_32]
		undefine
			copy, is_equal
		end

	HASH_TABLE [STRING_32, STRING]

create
	make

feature -- Status report

	variable (a_name: STRING): detachable STRING_32
		do
			Result := item (a_name)
		end

	has_variable (a_name: STRING): BOOLEAN
		do
			Result := has (a_name)
		end

feature {EWSGI_REQUEST, EWSGI_APPLICATION, EWSGI_CONNECTOR} -- Element change

	set_variable (a_name: STRING; a_value: STRING_32)
		do
			force (a_value, a_name)
		end

	unset_variable (a_name: STRING)
		do
			remove (a_name)
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
