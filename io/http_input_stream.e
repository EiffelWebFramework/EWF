note
	description: "Summary description for {HTTP_INPUT_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_INPUT_STREAM

create
	make

feature {NONE} -- Initialization

	make (a_socket: like source)
		do
			source := a_socket
			create last_string.make_empty
		end

	source: TCP_STREAM_SOCKET

feature -- Basic operation

	read_stream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of file.
			-- Make result available in `last_string'.	
		require
			nb_char_positive: nb_char > 0
		do
			last_string.wipe_out
			if source.socket_ok then
				source.read_stream_thread_aware (nb_char)
				last_string.append_string (source.last_string)
			end
		end

feature -- Access		

	last_string: STRING
			-- Last string read

end
