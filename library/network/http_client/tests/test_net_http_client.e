note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_NET_HTTP_CLIENT

inherit
	TEST_HTTP_CLIENT_I

feature -- Factory

	new_session (a_url: READABLE_STRING_8): HTTP_CLIENT_SESSION
		do
			create {NET_HTTP_CLIENT_SESSION} Result.make (a_url)
		end

feature -- Tests

	test_net_http_client
		do
			test_http_client
		end

	test_net_http_client_ssl
		do
			test_http_client_ssl
		end

	test_net_headers
		do
			test_headers
		end

end


