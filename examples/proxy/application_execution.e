note
	description: "Reverse proxy example."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute
		local
			l_forwarded: BOOLEAN
 		do
 				-- NOTE: please edit the proxy.conf file
 			across
 				proxy_map as ic
 			until
 				l_forwarded
 			loop
 				if request.path_info.starts_with_general (ic.key) then
 					l_forwarded := True
 					send_proxy_response (ic.key, ic.item, agent proxy_uri (ic.key, ?))
 				end
 			end
 			if not l_forwarded then
				response.send (create {WSF_PAGE_RESPONSE}.make_with_body ("EiffelWeb proxy: not forwarded!"))
			end
		end

	proxy_map: HASH_TABLE [STRING, STRING]
			-- location => target
		local
			f: PLAIN_TEXT_FILE
			l_line: STRING
			p: INTEGER
		once ("thread")
			create Result.make (1)
 				-- Load proxy.conf
 			create f.make_with_name ("proxy.conf")
 			if f.exists and then f.is_access_readable then
 				f.open_read
 				from
 				until
					f.end_of_file or f.exhausted
 				loop
					f.read_line
					l_line := f.last_string
					if l_line.starts_with ("#") then
							-- ignore
					else
							-- Format:
							-- path%Tserver
						p := l_line.index_of ('%T', 1)
						if p > 0 then
							Result.force (l_line.substring (p + 1, l_line.count), l_line.head (p - 1))
						end
					end
 				end
 				f.close
 			end
		end

	send_proxy_response (a_location, a_remote: READABLE_STRING_8; a_rewriter: detachable FUNCTION [WSF_REQUEST, STRING])
		local
			h: WSF_SIMPLE_REVERSE_PROXY_HANDLER
		do
			create h.make (a_remote)
			if a_rewriter /= Void then
				h.set_uri_rewriter (create {WSF_AGENT_URI_REWRITER}.make (a_rewriter))
			end
			h.set_timeout_ns (10_000_000_000) -- 10 seconds
			h.set_connect_timeout (5_000) -- milliseconds = 5 seconds

			-- Uncomment following, if you want to provide proxy information
--			h.set_header_via (True)
--			h.set_header_forwarded (True)
--			h.set_header_x_forwarded (True)
			-- Uncomment following line to keep the original Host value.
--			h.keep_proxy_host (True)

			h.execute (request, response)
		end

feature -- Helpers

	proxy_uri (a_location: READABLE_STRING_8; a_request: WSF_REQUEST): STRING
			-- Request uri rewriten as url.
		do
			Result := a_request.request_uri
				-- If related proxy setting is
				-- a_location=/foo -> http://foo.com
				-- and if request was http://example.com/foo/bar, it will use http://foo.com/bar
				-- so the Result here, is "/bar"
			if Result.starts_with (a_location) then
				Result.remove_head (a_location.count)
			end
		end

end
