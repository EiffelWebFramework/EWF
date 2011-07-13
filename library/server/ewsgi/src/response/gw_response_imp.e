note
	description: "Summary description for {GW_RESPONSE_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_RESPONSE_IMP

inherit
	GW_RESPONSE

create
	make

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			output := a_output
			create header.make
		end

feature -- Access: Input/Output

	output: GW_OUTPUT_STREAM
			-- Server output channel

	header: GW_HEADER
			-- Header for the response	

;note
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
