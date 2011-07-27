note
	description: "Summary description for {GW_APPLICATION_IMP} "
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_APPLICATION_IMP

inherit
	GW_APPLICATION
		redefine
			process,
			rescue_execute
		end

feature -- Access

	request_count: INTEGER
			-- Request count

feature -- Execution

	process (env: GW_ENVIRONMENT; a_input: GW_INPUT_STREAM; a_output: GW_OUTPUT_STREAM)
			-- Process request with environment `env', and i/o streams `a_input' and `a_output'
		do
			request_count := request_count + 1
			Precursor (env, a_input, a_output)
		end

	rescue_execute (req: detachable GW_REQUEST; res: detachable GW_RESPONSE; a_exception: detachable EXCEPTION)
			-- Operation processed on rescue of `execute'
		do
			if
				req /= Void and res /= Void
				and a_exception /= Void and then attached a_exception.exception_trace as l_trace
			then
				res.write_header ({HTTP_STATUS_CODE}.internal_server_error, Void)
				res.write_string ("<pre>" + l_trace + "</pre>")
			end
			Precursor (req, res, a_exception)
		end

feature -- Factory

	new_request (env: GW_ENVIRONMENT; a_input: GW_INPUT_STREAM): GW_REQUEST
		do
			create {GW_REQUEST_IMP} Result.make (env, a_input)
			Result.execution_variables.set_variable (request_count.out, "REQUEST_COUNT")
		end

	new_response (req: GW_REQUEST; a_output: GW_OUTPUT_STREAM): GW_RESPONSE
		do
			create {GW_RESPONSE_IMP} Result.make (a_output)
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
