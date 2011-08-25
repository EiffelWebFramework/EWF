note
	description: "Summary description for {EWF_CGI_CONNECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_CGI_CONNECTOR

inherit
	EWSGI_CONNECTOR

create
	make

feature -- Execution

	launch
		local
			req: EWSGI_REQUEST_FROM_TABLE
			res: EWSGI_RESPONSE_STREAM_BUFFER
		do
			create req.make ((create {EXECUTION_ENVIRONMENT}).starting_environment_variables, create {EWF_CGI_INPUT_STREAM}.make)
			create res.make (create {EWF_CGI_OUTPUT_STREAM}.make)
			application.process (req, res)
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
