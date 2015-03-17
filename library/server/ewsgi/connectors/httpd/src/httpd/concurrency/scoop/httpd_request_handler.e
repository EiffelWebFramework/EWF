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

feature -- Change

	set_listening_socket (a_listening_socket: separate HTTPD_STREAM_SOCKET)
		do
			listening_socket := a_listening_socket
		end

	accept_from_listening_socket (a_listening_socket: separate HTTPD_STREAM_SOCKET)
		local
			retried: BOOLEAN
			s: like client_socket
		do
			if retried then
				has_error := True
			else
				create s.make_empty
				client_socket := s
				debug ("dbglog")
					dbglog ("before accept_to")
				end
				print ("[EWF/DBG] <#" + processor_id_from_object (Current).out + "> accept_to%N")
				a_listening_socket.accept_to (s)

				if s.is_created then
					debug ("dbglog")
						dbglog ("after accept_to " + s.descriptor.out)
					end
				else
					debug ("dbglog")
						dbglog ("after accept_to ERROR")
					end

					has_error := True
					client_socket := Void
				end
			end
		rescue
			retried := True
			retry
		end

feature -- Execution

	separate_execution: BOOLEAN
		do
			Result := False
			if attached listening_socket as l_listening_socket then
				accept_from_listening_socket (l_listening_socket)
				if not has_error then
					if attached client_socket as s then
						execute (s)
						Result := True
					end
				end
			end
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
