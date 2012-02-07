note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_WSF_REQUEST_CHUNKED_INPUT

inherit
	TEST_WSF_REQUEST
		redefine
			adapted_context,
			test_get_request_01,
			test_post_request_01
		end

feature {NONE} -- Helpers

	adapted_context (ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_REQUEST_CONTEXT
		do
			Result := Precursor (ctx)
			Result.headers.extend ("chunked", "Transfer-Encoding")
--			Result.set_proxy ("127.0.0.1", 8888) --| inspect traffic with http://www.fiddler2.com/
		end

feature -- Test routines

	test_get_request_01
		do
			Precursor
		end

	test_post_request_01
		do
			Precursor
		end

end


