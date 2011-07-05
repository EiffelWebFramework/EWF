note
	description: "Summary description for {GW_VARIABLES}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_VARIABLES [G -> STRING_GENERAL]

feature -- Access

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

	variable (a_name: STRING): detachable G
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		deferred
		end

	has_variable (a_name: STRING): BOOLEAN
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		deferred
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
