note
	description : "Objects that ..."
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	APP_REQUEST_HANDLER

inherit
	REST_REQUEST_HANDLER [APP_REQUEST_HANDLER_CONTEXT]

	APP_REQUEST_HELPER

feature {NONE} -- Initialization

	initialize
			-- Initialize various attributes
		do
		end
		
feature {NONE} -- Implementation

	wgi_value_iteration_to_string (cur: ITERATION_CURSOR [WGI_VALUE]; using_pre: BOOLEAN): STRING_8
		do
			create Result.make (100)
			if using_pre then
				Result.append ("<pre>")
			end
			from
			until
				cur.after
			loop
				Result.append_string (cur.item.name.as_string_8 + " = " + cur.item.as_string.as_string_8 + "%N")
				cur.forth
			end
			if using_pre then
				Result.append ("</pre>")
			end
		end

feature -- Helpers

	format_id (s: detachable STRING): INTEGER
		do
			Result := {HTTP_FORMAT_CONSTANTS}.text
			if s /= Void then
				Result := format_constants.format_id (s)
			end
		end

	exit_with_code (a_code: INTEGER)
		do
			(create {EXCEPTIONS}).die (a_code)
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
