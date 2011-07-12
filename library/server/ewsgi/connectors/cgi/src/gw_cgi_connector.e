note
	description: "Summary description for {GW_CGI_CONNECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_CGI_CONNECTOR

inherit
	GW_CONNECTOR

create
	make

feature -- Execution

	launch
		local
			env: GW_ENVIRONMENT_VARIABLES
		do
			create env.make_with_variables ((create {EXECUTION_ENVIRONMENT}).starting_environment_variables)
			application.process (env, create {GW_CGI_INPUT_STREAM}.make, create {GW_CGI_OUTPUT_STREAM}.make)
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
