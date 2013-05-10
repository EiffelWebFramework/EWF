note
	description: "Summary description for {HTTP_CLIENT_RESPONSE_STATUS_CODE_EXPECTATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CLIENT_RESPONSE_STATUS_CODE_EXPECTATION
inherit
	HTTP_CLIENT_RESPONSE_EXPECTATION

create make

feature {NONE} -- Initialization
	make (a_status : INTEGER_32)
		do
			status := a_status
		ensure
			status_set :  status = a_status
		end

feature -- Result Expected
	expected (resp: HTTP_CLIENT_RESPONSE): BOOLEAN
		-- is `status' expected equals to resp.status?
		do
			Result := status = resp.status
		end

feature -- Access
	status : INTEGER_32
		-- status expected
;note
	copyright: "2011-2013, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
