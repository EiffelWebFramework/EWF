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

feature {HTTPD_CONNECTION_HANDLER_I} -- Basic operation		

	release (a_socket: HTTPD_STREAM_SOCKET)
		local
			d: STRING
		do
			-- FIXME: for log purpose
			d := a_socket.descriptor.out
			debug ("dbglog")
				dbglog (generator + ".release: ENTER {" + d + "}")
			end
			Precursor {HTTPD_REQUEST_HANDLER_I} (a_socket)
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
