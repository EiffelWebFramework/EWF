note
	description: "Summary description for {EWSGI_AGENT_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWSGI_AGENT_APPLICATION

inherit
	EWSGI_APPLICATION

create
	make

feature {NONE} -- Implementation

	make (a_callback: like callback; a_request_creator: like request_creator; a_response_creator: like response_creator)
			-- Initialize `Current'.
		do
			callback := a_callback
			request_creator := a_request_creator
			response_creator := a_response_creator
		end

feature {NONE} -- Implementation

	request_creator: FUNCTION [ANY, TUPLE [env: EWSGI_ENVIRONMENT; input: EWSGI_INPUT_STREAM], EWSGI_REQUEST]

	response_creator: FUNCTION [ANY, TUPLE [req: EWSGI_REQUEST; output: EWSGI_OUTPUT_STREAM], EWSGI_RESPONSE_STREAM]

	callback: PROCEDURE [ANY, TUPLE [req: like new_request; res: like new_response]]
			-- Procedure called on `execute'

	execute (req: like new_request; res: like new_response)
			-- Execute the request
		do
			callback.call ([req, res])
		end

feature -- Factory

	new_request (env: EWSGI_ENVIRONMENT; a_input: EWSGI_INPUT_STREAM): EWSGI_REQUEST
		do
			Result := request_creator.item ([env, a_input])
		end

	new_response (req: EWSGI_REQUEST; a_output: EWSGI_OUTPUT_STREAM): EWSGI_RESPONSE_STREAM
		do
			Result := response_creator.item ([req, a_output])
		end

invariant
	callback_attached: callback /= Void

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
