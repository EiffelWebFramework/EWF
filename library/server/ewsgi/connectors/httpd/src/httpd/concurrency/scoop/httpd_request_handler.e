note
	description: "[
			 Instance of HTTPD_REQUEST_HANDLER will process the incoming connection
			 and extract information on the request and the server
		 ]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTPD_REQUEST_HANDLER

inherit
	HTTPD_REQUEST_HANDLER_I
		redefine
			release
		end

	CONCURRENT_POOL_ITEM
		rename
			release as release_pool_item
		end

feature -- Status report

	is_connected: BOOLEAN
			-- Is handler connected to incoming request via `client_socket'?
		do
			Result := client_socket.descriptor_available
		end

feature -- Execution

	separate_execute
		local
			retried: BOOLEAN
		do
			if retried then
				release (client_socket)
			else
				if
					not has_error and then
					is_connected
				then
					execute (client_socket)
				end
				separate_release
			end
		rescue
			retried := True
			retry
		end

feature {CONCURRENT_POOL, HTTPD_CONNECTION_HANDLER_I} -- Basic operation		

	separate_release
		do
			release (client_socket)
		end

	release (a_socket: detachable HTTPD_STREAM_SOCKET)
		local
			d: STRING
		do
			if a_socket /= Void then
				d := a_socket.descriptor.out
			else
				d := "N/A"
			end
			debug ("dbglog")
				dbglog (generator + ".release: ENTER {" + d + "}")
			end
			Precursor {HTTPD_REQUEST_HANDLER_I} (a_socket)
			release_pool_item
			debug ("dbglog")
				dbglog (generator + ".release: LEAVE {" + d + "}")
			end
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
