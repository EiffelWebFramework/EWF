note
	description : "[
			Interface to access the variable stored in a container
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"
	
deferred class
	GW_VARIABLES [G -> STRING_GENERAL]

feature -- Status report

	has_variable (a_name: STRING): BOOLEAN
			-- Has variable associated with `a_name'
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		deferred
		end

feature -- Access

	variable (a_name: STRING): detachable G
			-- Value for variable associated with `a_name'
			-- If not found, return Void
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		deferred
		end

	variable_or_default (a_name: STRING; a_default: G): G
			-- Value for variable `a_name'
			-- If not found, return `a_default'
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			if attached variable (a_name) as s then
				Result := s
			else
				Result := a_default
			end
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
