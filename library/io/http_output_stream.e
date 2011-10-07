note
	description: "Summary description for {HTTP_OUTPUT_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_OUTPUT_STREAM

create
	make

feature {NONE} -- Initialization

	make (a_socket: like target)
		do
			target := a_socket
		end

	target: TCP_STREAM_SOCKET

feature -- Basic operation

	put_string (s: STRING)
			-- Write string `s' to `target'
		do
			target.put_string (s)
		end

note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
