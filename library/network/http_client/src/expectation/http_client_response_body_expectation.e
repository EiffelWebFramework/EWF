note
	description: "Summary description for {HTTP_CLIENT_RESPONSE_BODY_EXPECTATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CLIENT_RESPONSE_BODY_EXPECTATION
inherit
	HTTP_CLIENT_RESPONSE_EXPECTATION
create
	make

feature {NONE} -- Initializtion
	make (a_body : detachable STRING_32)
		-- Create and Initialize a body expectation
		do
			body := a_body
		ensure
			body_set : body ~ a_body
		end

feature -- Result expected
	expected (resp: HTTP_CLIENT_RESPONSE): BOOLEAN
		-- is `body expected' equals to resp.body?
		do
			if body = Void and then resp.body = Void then
				Result := True
			elseif attached resp.body as l_body and then attached body as c_body then
				Result := l_body.is_case_insensitive_equal (c_body)
			end
		end

feature -- Access
	body : detachable STRING_32
		-- expected body

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
