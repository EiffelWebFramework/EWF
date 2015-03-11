note
	description: "[
				Specific implementation of HTTP_CLIENT_REQUEST based on Eiffel NET library
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	NET_HTTP_CLIENT_REQUEST

inherit
	HTTP_CLIENT_REQUEST
		redefine
			session
		end

	REFACTORING_HELPER

create
	make

feature {NONE} -- Internal	

	session: NET_HTTP_CLIENT_SESSION

feature -- Access

	response: HTTP_CLIENT_RESPONSE
			-- <Precursor>
		do
			to_implement ("implementation based on EiffelNET")
			(create {EXCEPTIONS}).die (0)
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
