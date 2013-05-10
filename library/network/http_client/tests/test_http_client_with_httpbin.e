note
	description: "Summary description for {TEST_HTTP_CLIENT_WITH_HTTPBIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=HTTP TESTING", "protocol=uri", "src=http://httpbin.org/"

class
	TEST_HTTP_CLIENT_WITH_HTTPBIN

inherit
	EQA_TEST_SET

feature
	test_origin_ip
		local
			h: LIBCURL_HTTP_CLIENT
			sess: HTTP_CLIENT_SESSION
			resp : detachable HTTP_CLIENT_RESPONSE
			l_location : detachable READABLE_STRING_8
			body : STRING
			context : HTTP_CLIENT_REQUEST_CONTEXT
			s: READABLE_STRING_8
		do
			create h.make
			sess := h.new_session ("http://httpbin.org/")
			resp := sess.get ("",void)
			assert ("Expected Status 200 ok", resp.status = 200)
		end

	test_status_code
		local
			h: LIBCURL_HTTP_CLIENT
			sess: HTTP_CLIENT_SESSION
			resp : detachable HTTP_CLIENT_RESPONSE
			l_location : detachable READABLE_STRING_8
			body : STRING
			context : HTTP_CLIENT_REQUEST_CONTEXT
			s: READABLE_STRING_8
		do
			create h.make
			sess := h.new_session ("http://httpbin.org/")
			assert ("Expected Status 200 ok", (create {HTTP_CLIENT_RESPONSE_STATUS_CODE_EXPECTATION}.make(200)).expected(sess.get ("",void)) )
		end

	test_body
		local
			h: LIBCURL_HTTP_CLIENT
			sess: HTTP_CLIENT_SESSION
			resp : detachable HTTP_CLIENT_RESPONSE
			l_location : detachable READABLE_STRING_8
			body : STRING
			context : HTTP_CLIENT_REQUEST_CONTEXT
			s: READABLE_STRING_8
		do
			create h.make
			sess := h.new_session ("http://httpbin.org/")
			assert ("Expected no body", (create {HTTP_CLIENT_RESPONSE_BODY_EXPECTATION}.make(expected_body_get)).expected(sess.get ("get",void)) )
		end

	test_body_status
		local
			h: LIBCURL_HTTP_CLIENT
			sess: HTTP_CLIENT_SESSION
			resp : detachable HTTP_CLIENT_RESPONSE
			l_location : detachable READABLE_STRING_8
			body : STRING
			context : HTTP_CLIENT_REQUEST_CONTEXT
			s: READABLE_STRING_8
		do
			create h.make
			sess := h.new_session ("http://httpbin.org/")
			--assert ("Expected no body", (create {HTTP_CLIENT_RESPONSE_STATUS_CODE_EXPECTATION}.make(200)  + create {HTTP_CLIENT_RESPONSE_BODY_EXPECTATION}.make(expected_body_get)).expected(sess.get ("get",void)) )
		end


	test_after_post_should_continue_working
		local
				h: LIBCURL_HTTP_CLIENT
				sess: HTTP_CLIENT_SESSION
				resp : detachable HTTP_CLIENT_RESPONSE
				l_location : detachable READABLE_STRING_8
				body : STRING
				context : HTTP_CLIENT_REQUEST_CONTEXT
				s: READABLE_STRING_8
			do
				create h.make
				sess := h.new_session ("http://httpbin.org/")
				resp := sess.get ("",void)
				assert ("Expected Status 200 ok", resp.status = 200)

				create context.make
				context.headers.put ("text/plain;charset=UTF-8", "Content-Type")
				resp := sess.post ("post", context, "testing post")
				assert ("Expected Status 200 ok", resp.status = 200)

				sess := h.new_session ("http://httpbin.org/")
				resp := sess.get ("",void)
				assert ("Expected Status 200 ok", resp.status = 200)

				sess := h.new_session ("http://httpbin.org/")
				resp := sess.get ("redirect/1",void)
				assert ("Expected Status 200 ok", resp.status = 200)

			end



expected_body_get : STRING_32 = "[
{
  "url": "http://httpbin.org/get",
  "args": {},
  "headers": {
    "Host": "httpbin.org",
    "Connection": "close",
    "Accept": "*/*"
  },
   "origin": "190.177.106.187"
}
]"
end
