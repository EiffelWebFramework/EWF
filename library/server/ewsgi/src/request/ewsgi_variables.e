note
	description : "[
			Interface to access the variable stored in a container
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EWSGI_VARIABLES [G -> STRING_GENERAL]

inherit
	ITERABLE [G]

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

	variable_or_default (a_name: STRING; a_default: G; use_default_when_empty: BOOLEAN): G
			-- Value for variable `a_name'
			-- If not found, return `a_default'
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			if attached variable (a_name) as s then
				if use_default_when_empty and then s.is_empty then
					Result := a_default
				else
					Result := s
				end
			else
				Result := a_default
			end
		end

feature {EWSGI_REQUEST, EWSGI_APPLICATION, EWSGI_CONNECTOR} -- Element change

	set_variable (a_name: STRING; a_value: G)
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		deferred
		ensure
			variable_set: has_variable (a_name) and then variable (a_name) ~ a_value
		end

	unset_variable (a_name: STRING)
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		deferred
		ensure
			variable_unset: not has_variable (a_name)
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
