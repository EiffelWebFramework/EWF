note
	description: "Summary description for {SSL_SMTP_PROTOCOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSL_SMTP_PROTOCOL

inherit
	SMTP_PROTOCOL
		redefine
			socket
		end

create
	make

feature -- Access

	socket: detachable SSL_NETWORK_STREAM_SOCKET
		-- Socket use to communicate

invariant

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
