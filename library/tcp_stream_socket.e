note
	description: "Summary description for {TCP_STREAM_SOCKET}."
	date: "$Date$"
	revision: "$Revision$"

class
	TCP_STREAM_SOCKET

inherit
	NETWORK_STREAM_SOCKET

create
	make_server_by_port

create {NETWORK_STREAM_SOCKET}
	make_from_descriptor_and_address

feature -- Basic operation

	send_message (a_msg: STRING)
		local
			a_package : PACKET
			a_data : MANAGED_POINTER
			c_string : C_STRING
		do
			create c_string.make (a_msg)
			create a_data.make_from_pointer (c_string.item, a_msg.count + 1)
			create a_package.make_from_managed_pointer (a_data)
			send (a_package, 1)
		end

note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
