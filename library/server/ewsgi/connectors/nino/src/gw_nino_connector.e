note
	description: "Summary description for {GW_NINO_CONNECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_NINO_CONNECTOR

inherit
	GW_CONNECTOR
		redefine
			initialize
		end

create
	make,
	make_with_base

feature {NONE} -- Initialization

	make_with_base (a_app: like application; a_base: like base)
		do
			make (a_app)
			base := a_base
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
		do
			base := b
		end

feature -- Server

	launch
		local
			l_http_handler : HTTP_HANDLER
		do
			create {GW_NINO_HANDLER} l_http_handler.make_with_callback (server, "GW_NINO_HANDLER", Current)
			debug ("nino")
				if attached base as l_base then
					print ("Base=" + l_base + "%N")
				end
			end
			server.setup (l_http_handler)
		end

	process_request (env: HASH_TABLE [STRING, STRING]; a_headers_text: STRING; a_input: HTTP_INPUT_STREAM; a_output: HTTP_OUTPUT_STREAM)
		local
			gw_env: GW_ENVIRONMENT_VARIABLES
		do
			create gw_env.make_with_variables (env)
			gw_env.set_variable ("RAW_HEADER_DATA", a_headers_text)
			application.process (gw_env, create {GW_NINO_INPUT_STREAM}.make (a_input), create {GW_NINO_OUTPUT_STREAM}.make (a_output))
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
