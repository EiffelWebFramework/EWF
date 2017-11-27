note
	description: "Summary description for {WSF_PROTECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PROTECTION

feature -- Status report

	is_valid: BOOLEAN
		deferred
		end

feature -- String Protection

	string_8 (s: READABLE_STRING_8): detachable READABLE_STRING_8
		require
			is_valid: is_valid
		deferred
		end

feature -- Value Protection

	value (v: WSF_VALUE): detachable WSF_VALUE
		require
			is_valid: is_valid
		do
			if attached {WSF_STRING} v as s then
				Result := string_value (s)
			elseif attached {WSF_MULTIPLE_STRING} v as ms then
				Result := multiple_string_value (ms)
			else
					-- TODO
				Result := v
			end
		end

	string_value (v: WSF_STRING): detachable WSF_STRING
		require
			is_valid: is_valid
		deferred
		end

	multiple_string_value (mv: WSF_MULTIPLE_STRING): detachable WSF_MULTIPLE_STRING
		require
			is_valid: is_valid
		local
			v: detachable WSF_STRING
		do
			across
				mv as ic
			loop
				v := string_value (ic.item)
				if v = Void then
					Result := Void
				elseif Result = Void then
					create Result.make_with_value (v)
				else
					Result.add_value (v)
				end
			end
		end

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
