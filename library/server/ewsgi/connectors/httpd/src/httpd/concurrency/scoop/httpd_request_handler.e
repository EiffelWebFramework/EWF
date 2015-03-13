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
--			set_client_socket,			
			release,
			reset
		end

	CONCURRENT_POOL_ITEM
		rename
			release as release_pool_item
		end

feature {NONE} -- Initialization

	reset
		do
			if attached client_socket_source as l_sock then
				cleanup_separate_socket (l_sock)
			end
			Precursor
			client_socket_source := Void
		end

	cleanup_separate_socket (a_socket: attached like client_socket_source)
		do
			a_socket.cleanup
		end

feature -- Access

	client_socket: detachable HTTPD_STREAM_SOCKET

	client_socket_source: detachable separate HTTPD_STREAM_SOCKET
				-- Associated original client socket
				-- kept to avoid being closed when disposed,
				-- and thus avoid closing related `client_socket'.		

feature -- Change

	set_client_socket (a_socket: separate HTTPD_STREAM_SOCKET)
		local
			retried: BOOLEAN
		do
			if retried then
				has_error := True
			else
				create client_socket.make_from_separate (a_socket)
				client_socket_source := a_socket
			end
		rescue
			retried := True
			retry
		end

feature -- Execution

	separate_execution: BOOLEAN
		do
			if attached client_socket as s then
				execute (s)
			end
			Result := True
		end

feature {CONCURRENT_POOL, HTTPD_CONNECTION_HANDLER_I} -- Basic operation		

	separate_release
		do
			if attached client_socket as s then
				release (s)
			end
		end

	release (a_socket: HTTPD_STREAM_SOCKET)
		local
			d: STRING
		do
			d := a_socket.descriptor.out
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
	copyright: "2011-2014, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
