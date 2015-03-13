note
	description: "Summary description for {HTTPD_DEBUG_FACILITIES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTPD_DEBUG_FACILITIES

feature {NONE} -- Output

	dbglog (m: READABLE_STRING_8)
		require
			not m.ends_with_general ("%N")
		do
			debug ("dbglog")
				print ("[EWF/DBG] <#" + processor_id_from_object (Current).out + "> " + m + "%N")
			end
		end

feature -- runtime

	frozen processor_id_from_object (a_object: separate ANY): INTEGER_32
		external
			"C inline use %"eif_scoop.h%""
		alias
			"RTS_PID(eif_access($a_object))"
		end

note
	copyright: "2011-2014, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
