note
	description: "Summary description for {HTTP_CLIENT_HEADER_EXPECTATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CLIENT_HEADER_EXPECTATION
inherit
	HTTP_CLIENT_RESPONSE_EXPECTATION
create
	make

feature {NONE} -- Initializtion
	make (a_header: STRING_32; a_value : STRING)
		-- Create and Initialize a header expectation
		do
			header := a_header
			value  := a_value
		ensure
			header_set : header ~ a_header
			value_set : value ~ a_value
		end

feature -- Result expected
	expected (resp: HTTP_CLIENT_RESPONSE): BOOLEAN
		-- is `header name and value expected' equals to resp.header(name)?
		do
			if attached {READABLE_STRING_8} resp.header (header) as l_value then
				if l_value.same_string (l_value) then
					Result := true
				end
			end
		end

feature -- Access
	header : STRING
		-- header name
	value : STRING
		-- header value	
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
