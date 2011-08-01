note
	description: "Summary description for {GW_IN_MEMORY_RESPONSE_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_IN_MEMORY_RESPONSE_APPLICATION

inherit
	EWSGI_APPLICATION
		redefine
			new_response
		end

feature -- Factory

	new_response (req: EWSGI_REQUEST; a_output: EWSGI_OUTPUT_STREAM): GW_IN_MEMORY_RESPONSE
		do
			create {GW_IN_MEMORY_RESPONSE} Result.make (a_output)
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
