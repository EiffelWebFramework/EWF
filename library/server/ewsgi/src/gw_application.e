note
	description: "Summary description for {GW_APPLICATION}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_APPLICATION

feature -- Process request

	process (env: GW_ENVIRONMENT; a_input: GW_INPUT_STREAM; a_output: GW_OUTPUT_STREAM)
			-- Process request with environment `env', and i/o streams `a_input' and `a_output'
		local
			rescued: BOOLEAN
			ctx: detachable GW_REQUEST_CONTEXT
		do
			if not rescued then
				pre_execute (env)
				ctx := new_request_context (env, a_input, a_output)
				execute (ctx)
				post_execute (ctx)
			else
				rescue_execute (ctx, (create {EXCEPTION_MANAGER}).last_exception)
			end
		end

feature {NONE} -- Execution

	execute (ctx: GW_REQUEST_CONTEXT)
			-- Execute the request
		deferred
		end

	pre_execute (env: GW_ENVIRONMENT)
			-- Operation processed before `execute'
		require
			env_attached: env /= Void
		do
		end

	post_execute (ctx: detachable GW_REQUEST_CONTEXT)
			-- Operation processed after `execute', or after `rescue_execute'
		do
		end

	rescue_execute (ctx: detachable GW_REQUEST_CONTEXT; a_exception: detachable EXCEPTION)
			-- Operation processed on rescue of `execute'
		do
			post_execute (ctx)
		end

feature -- Factory

	new_request_context (env: GW_ENVIRONMENT; a_input: GW_INPUT_STREAM; a_output: GW_OUTPUT_STREAM): GW_REQUEST_CONTEXT
			-- New Gateway Context based on `env' `a_input' and `a_output'
			--| note: you can redefine this function to create your own
			--| descendant of GW_REQUEST_CONTEXT , or even to reuse/recycle existing
			--| instance of GW_REQUEST_CONTEXT	
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
