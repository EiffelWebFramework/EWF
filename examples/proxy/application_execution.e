note
	description: "Reverse proxy example."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

	WSF_URI_REWRITER
		rename
			uri as proxy_uri
		end

create
	make

feature -- Basic operations

	execute
 		do
 				-- NOTE: please enter the target reverse proxy machine + port number here
 				-- replace "localhost" and 8080
			send_proxy_response ("localhost", 8080, Current)
		end

	send_proxy_response (a_hostname: READABLE_STRING_8; a_port: INTEGER; a_rewriter: detachable WSF_URI_REWRITER)
		local
			h: WSF_SIMPLE_REVERSE_PROXY_HANDLER
		do
			create h.make (a_hostname, a_port)
			h.set_uri_rewriter (a_rewriter)
			h.set_uri_rewriter (create {WSF_AGENT_URI_REWRITER}.make (agent proxy_uri))
			h.set_timeout (30) -- 30 seconds
			h.set_connect_timeout (5_000) -- milliseconds = 5 seconds
			h.execute (request, response)
		end

feature -- Helpers

	proxy_uri (a_request: WSF_REQUEST): STRING
			-- Request uri rewriten as url.
		do
			Result := a_request.request_uri
		end

end
