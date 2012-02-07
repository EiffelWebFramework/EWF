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
			test_get_request_01,
			test_post_request_01
		end

feature -- Test routines

	test_get_request_01
			-- New test routine
		local
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
		do
			get_http_session
			if attached http_session as sess then
--				create ctx.make
--				ctx.set_proxy ("127.0.0.1", 8888) --| debugging with http://www.fiddler2.com/

				test_get_request ("get/01", ctx, "get-01")
				test_get_request ("get/01/?foo=bar", ctx, "get-01(foo=bar)")
				test_get_request ("get/01/?foo=bar&abc=def", ctx, "get-01(foo=bar&abc=def)")
				test_get_request ("get/01/?lst=a&lst=b", ctx, "get-01(lst=[a,b])")
			else
				assert ("not_implemented", False)
			end
		end

	test_post_request_01
			-- New test routine
		local
			ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
			get_http_session
			if attached http_session as sess then
				create ctx.make
				ctx.add_form_parameter ("id", "123")
				ctx.headers.extend ("chunked", "Transfer-Encoding")
--				ctx.set_proxy ("127.0.0.1", 8888) --| debugging with http://www.fiddler2.com/

				test_post_request ("post/01", ctx, "post-01 : id=123")
				test_post_request ("post/01/?foo=bar", ctx, "post-01(foo=bar) : id=123")
				test_post_request ("post/01/?foo=bar&abc=def", ctx, "post-01(foo=bar&abc=def) : id=123")
				test_post_request ("post/01/?lst=a&lst=b", ctx, "post-01(lst=[a,b]) : id=123")
			else
				assert ("not_implemented", False)
			end
		end

end


