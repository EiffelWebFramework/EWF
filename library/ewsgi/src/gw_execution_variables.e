note
	description: "Summary description for {HTTPD_EXECUTION_VARIABLES}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_EXECUTION_VARIABLES

inherit
	GW_VARIABLES [STRING_32]
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

feature -- Element change

	replace_variable (v: STRING; k: STRING)
			-- Replace variable `k'
		do
			force (v, k)
		end

	add_variable (v: STRING; k: STRING)
			-- Add variable `k' with value `v'
		require
			k_attached: k /= Void
			v_attached: k /= Void
		do
			force (v, k)
		end

	delete_variable (k: STRING)
			-- Remove variable `k'
		require
			k_attached: k /= Void
		do
			remove (k)
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
