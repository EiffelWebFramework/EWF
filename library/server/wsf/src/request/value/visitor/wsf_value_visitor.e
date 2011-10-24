note
	description: "[
			Component to visit WSF_VALUE
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_VALUE_VISITOR

feature -- Visitor

	safe_process_value (v: detachable WSF_TABLE_VALUE)
		do
			if v /= Void then
				v.process (Current)
			end
		end

	process_table (v: WSF_TABLE_VALUE)
		require
			v_attached: v /= Void
		deferred
		end

	process_string (v: WSF_STRING_VALUE)
		require
			v_attached: v /= Void
		deferred
		end

	process_multiple_string (v: WSF_MULTIPLE_STRING_VALUE)
		require
			v_attached: v /= Void
		deferred
		end

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
