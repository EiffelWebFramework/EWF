note
	description: "[
				WGI_APPLICATION
			]"
	specification: "EWSGI specification https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki/EWSGI-specification"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_APPLICATION

feature -- Execution

	execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute the request
			-- See `req.input' for input stream
			--     `req.environment' for the Gateway environment	
			-- and `res' for output buffer
		require
			res_status_unset: not res.status_is_set
		deferred
		ensure
			res_status_set: res.status_is_set
--			res_committed: res.message_committed
		end

feature -- Process request

	process (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Process request with environment `env', and i/o streams `a_input' and `a_output'
		local
			rescued: BOOLEAN
		do
			if not rescued then
				request_count := request_count + 1
				pre_execute (req)
				execute (req, res)
				post_execute (req, res)
			else
				rescue_execute (req, res, (create {EXCEPTION_MANAGER}).last_exception)
			end
			if res /= Void then
				res.commit
			end
		end

feature -- Access

	request_count: INTEGER
			-- Request count

feature {NONE} -- Execution

	pre_execute (req: WGI_REQUEST)
			-- Operation processed before `execute'
		do
		end

	post_execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Operation processed after `execute', or after `rescue_execute'
		do
		end

	rescue_execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER; a_exception: detachable EXCEPTION)
			-- Operation processed on rescue of `execute'
		do
			if
				a_exception /= Void and then attached a_exception.exception_trace as l_trace
			then
				res.write_header ({HTTP_STATUS_CODE}.internal_server_error, Void)
				res.write_string ("<pre>" + l_trace + "</pre>")
			end
			post_execute (req, res)
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
