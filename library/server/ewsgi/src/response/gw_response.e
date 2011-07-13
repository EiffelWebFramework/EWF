note
	description: "Summary description for {GW_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_RESPONSE

feature -- Access: Output

	output: GW_OUTPUT_STREAM
			-- Server output channel
		deferred
		end

	send_header
			-- Send `header' to `output'.
		do
			header.send_to (output)
		end

feature -- Header

	header: GW_HEADER
			-- Header for the response
		deferred
		end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
