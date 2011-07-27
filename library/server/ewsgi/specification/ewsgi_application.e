note
	description: "Summary description for {EWSGI_APPLICATION}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EWSGI_APPLICATION

feature -- Process request

	process (env: EWSGI_ENVIRONMENT; a_input: EWSGI_INPUT_STREAM; a_output: EWSGI_OUTPUT_STREAM)
			-- Process request with environment `env', and i/o streams `a_input' and `a_output'
		local
			rescued: BOOLEAN
			req: detachable like new_request
			res: detachable like new_response
		do
			if not rescued then
				pre_execute (env)
				req := new_request (env, a_input)
				res := new_response (req, a_output)
				execute (req, res)
				post_execute (req, res)
			else
				rescue_execute (req, res, (create {EXCEPTION_MANAGER}).last_exception)
			end
			if res /= Void then
				res.commit (a_output)
			end
		end

feature {NONE} -- Execution

	execute (req: EWSGI_REQUEST; res: EWSGI_RESPONSE_STREAM)
			-- Execute the request
			-- See `req.input' for input stream
			--     `req.environment' for the Gateway environment	
			-- and `res.output' for output stream
		deferred
		end

	pre_execute (env: EWSGI_ENVIRONMENT)
			-- Operation processed before `execute'
		require
			env_attached: env /= Void
		do
		end

	post_execute (req: detachable EWSGI_REQUEST; res: detachable EWSGI_RESPONSE_STREAM)
			-- Operation processed after `execute', or after `rescue_execute'
		do
		end

	rescue_execute (req: detachable EWSGI_REQUEST; res: detachable EWSGI_RESPONSE_STREAM; a_exception: detachable EXCEPTION)
			-- Operation processed on rescue of `execute'
		do
			post_execute (req, res)
		end

feature -- Factory

	new_request (env: EWSGI_ENVIRONMENT; a_input: EWSGI_INPUT_STREAM): EWSGI_REQUEST
			-- New Request context based on `env' and `a_input'
			--| note: you can redefine this function to create your own
			--| descendant of EWSGI_REQUEST , or even to reuse/recycle existing
			--| instance of EWSGI_REQUEST	
		deferred
		end

	new_response (req: EWSGI_REQUEST; a_output: EWSGI_OUTPUT_STREAM): EWSGI_RESPONSE_STREAM
			-- New Response based on `req' and `a_output'
			--| note: you can redefine this function to create your own
			--| descendant of EWSGI_RESPONSE_STREAM , or even to reuse/recycle existing
			--| instance of EWSGI_RESPONSE_STREAM	
		deferred
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
