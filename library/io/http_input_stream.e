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

feature -- Status Report

	is_readable: BOOLEAN
			-- Is readable?
		do
			Result := source.is_open_read
		end

feature -- Basic operation

	read_line
		require
            is_readable: is_readable
		do
			last_string.wipe_out
			if source.socket_ok then
				source.read_line_thread_aware
				last_string.append_string (source.last_string)
			end
		end

	read_stream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of file.
			-- Make result available in `last_string'.	
		require
			nb_char_positive: nb_char > 0
            is_readable: is_readable
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

;note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
