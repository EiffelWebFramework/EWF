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
			process
		end

feature -- Access

	request_count: INTEGER
			-- Request count

feature -- Execution

	process (env: EWSGI_ENVIRONMENT; a_input: EWSGI_INPUT_STREAM; a_output: EWSGI_OUTPUT_STREAM)
			-- Process request with environment `env', and i/o streams `a_input' and `a_output'
		do
			request_count := request_count + 1
			Precursor (env, a_input, a_output)
		end

feature -- Factory

	new_request (env: EWSGI_ENVIRONMENT; a_input: EWSGI_INPUT_STREAM): EWSGI_REQUEST
		do
			create {GW_REQUEST_IMP} Result.make (env, a_input)
			Result.execution_variables.set_variable (request_count.out, "REQUEST_COUNT")
		end

	new_response (req: EWSGI_REQUEST; a_output: EWSGI_OUTPUT_STREAM): GW_IN_MEMORY_RESPONSE
		do
			create {GW_IN_MEMORY_RESPONSE} Result.make
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
