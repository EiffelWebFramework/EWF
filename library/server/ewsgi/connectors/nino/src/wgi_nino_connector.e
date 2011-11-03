note
	description: "Summary description for {WGI_NINO_CONNECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_NINO_CONNECTOR

inherit
	WGI_CONNECTOR
		redefine
			initialize
		end

create
	make,
	make_with_base

feature {NONE} -- Initialization

	make_with_base (a_app: like application; a_base: like base)
		require
			a_base_starts_with_slash: (a_base /= Void and then not a_base.is_empty) implies a_base.starts_with ("/")
		do
			make (a_app)
			set_base (a_base)
		end

feature {NONE} -- Initialization

	initialize
		local
			cfg: HTTP_SERVER_CONFIGURATION
		do
			create cfg.make
			create server.make (cfg)
		end

feature -- Access

	server: HTTP_SERVER

	configuration: HTTP_SERVER_CONFIGURATION
		do
			Result := server.configuration
		end

feature -- Access

	base: detachable STRING
			-- Root url base

feature -- Element change

	set_base (b: like base)
		require
			b_starts_with_slash: (b /= Void and then not b.is_empty) implies b.starts_with ("/")
		do
			base := b
		ensure
			valid_base: (attached base as l_base and then not l_base.is_empty) implies l_base.starts_with ("/")
		end

feature -- Server

	launch
		local
			l_http_handler : HTTP_HANDLER
		do
			create {WGI_NINO_HANDLER} l_http_handler.make_with_callback (server, "NINO_HANDLER", Current)
			if configuration.is_verbose then
				if attached base as l_base then
					print ("Base=" + l_base + "%N")
				end
			end
			server.setup (l_http_handler)
		end

	process_request (env: HASH_TABLE [STRING, STRING]; a_headers_text: STRING; a_input: HTTP_INPUT_STREAM; a_output: HTTP_OUTPUT_STREAM)
		local
			req: WGI_REQUEST_FROM_TABLE
			res: detachable WGI_RESPONSE_STREAM_BUFFER
			rescued: BOOLEAN
		do
			if not rescued then
				create req.make (env, create {WGI_NINO_INPUT_STREAM}.make (a_input))
				create res.make (create {WGI_NINO_OUTPUT_STREAM}.make (a_output))
				req.set_meta_string_variable ("RAW_HEADER_DATA", a_headers_text)
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
