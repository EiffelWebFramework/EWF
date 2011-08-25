note
	description: "Summary description for {GW_LIBFCGI_CONNECTOR}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_LIBFCGI_CONNECTOR

inherit
	EWSGI_CONNECTOR
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			create fcgi.make
			create {GW_LIBFCGI_INPUT_STREAM} input.make (fcgi)
			create {GW_LIBFCGI_OUTPUT_STREAM} output.make (fcgi)
		end

feature -- Server

	launch
		local
			res: INTEGER
		do
			from
				res := fcgi.fcgi_listen
			until
				res < 0
			loop
				process_fcgi_request (fcgi.updated_environ_variables, input, output)
				res := fcgi.fcgi_listen
			end
		end

feature -- Execution

	process_fcgi_request (vars: HASH_TABLE [STRING, STRING]; a_input: like input; a_output: like output)
		local
			req: EWSGI_REQUEST_FROM_TABLE
			res: EWSGI_RESPONSE_STREAM_BUFFER
		do
			create req.make (vars, a_input)
			create res.make (a_output)
			application.process (req, res)
		end

feature -- Input/Output

	input: EWSGI_INPUT_STREAM
			-- Input from client (from httpd server via FCGI)

	output: EWSGI_OUTPUT_STREAM
			-- Output to client (via httpd server/fcgi)

feature {NONE} -- Implementation

	fcgi: FCGI

invariant
	fcgi_attached: fcgi /= Void

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
