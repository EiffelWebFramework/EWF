note
	description: "Summary description for {EWF_LIBFCGI_CONNECTOR}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_LIBFCGI_CONNECTOR

inherit
	WGI_CONNECTOR
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			create fcgi.make
			create {EWF_LIBFCGI_INPUT_STREAM} input.make (fcgi)
			create {EWF_LIBFCGI_OUTPUT_STREAM} output.make (fcgi)
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
			req: WGI_REQUEST_FROM_TABLE
			res: detachable WGI_RESPONSE_STREAM_BUFFER
			rescued: BOOLEAN
		do
			if not rescued then
				create req.make (vars, a_input)
				create res.make (a_output)
				application.execute (req, res)
			else
				if attached (create {EXCEPTION_MANAGER}).last_exception as e and then attached e.exception_trace as l_trace then
					if res /= Void then
						if not res.status_is_set then
							res.write_header ({HTTP_STATUS_CODE}.internal_server_error, Void)
						end
						if res.message_writable then
							res.write_string ("<pre>" + l_trace + "</pre>")
						end
					end
				end
			end
		rescue
			rescued := True
			retry
		end

feature -- Input/Output

	input: WGI_INPUT_STREAM
			-- Input from client (from httpd server via FCGI)

	output: WGI_OUTPUT_STREAM
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
