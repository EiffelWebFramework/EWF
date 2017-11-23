note
	description: "Summary description for {TEST_WSF_PROTECTION_POLICY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_WSF_PROTECTION_POLICY

inherit
	EQA_TEST_SET
	WSF_SERVICE
		undefine
			default_create
		end

feature -- Test

	test_http_expect_attack_without_xss_protection
		local
			req: WSF_REQUEST

		do
			--| Case HTTP header expect attack, no filtered.
			req := new_request (<<
						["REQUEST_METHOD", "GET"],
						["QUERY_STRING", ""],
						["REQUEST_URI", "/cookie"],
						["HTTP_EXPECT", "<script>alert(XSS attack)</script>"]
					>>
				)
				-- no filter
			assert ("HTTP_EXPECT <script>alert(XSS attack)</script>", attached req.http_expect as v and then v.is_case_insensitive_equal ("<script>alert(XSS attack)</script>"))
		end

	test_http_expect_attack_with_xss_protection
		local
			req: WSF_REQUEST
			sec: WSF_PROTECTION_POLICY
			l_protection: WSF_PROTECTION_PATTERNS
		do
			create sec
			--| Case HTTP header expect attack, filtered using {xss_regular_expression}
			req := new_request (<<
						["REQUEST_METHOD", "GET"],
						["QUERY_STRING", ""],
						["REQUEST_URI", "/xss_example"],
						["HTTP_EXPECT", "<script>alert(XSS attack)</script>"]
					>>
				)
			assert ("HTTP_EXPECT <script>alert(XSS attack)</script>", attached {READABLE_STRING_8} sec.custom_http_expect (req, {ARRAY [REGULAR_EXPRESSION]}<<l_protection.xss_regular_expression>>) as v and then v.is_empty )
		end


	test_http_expect_attack_with_xss_js_protection
		local
			req: WSF_REQUEST
			sec: WSF_PROTECTION_POLICY
			l_protection: WSF_PROTECTION_PATTERNS
		do
			create sec
			--| Case HTTP header expect attack, filtered using {xss_javascript_expression}
			req := new_request (<<
						["REQUEST_METHOD", "GET"],
						["QUERY_STRING", ""],
						["REQUEST_URI", "/xss_example"],
						["HTTP_EXPECT", "<script>alert(XSS attack)</script>"]
					>>
				)
			assert ("HTTP_EXPECT <script>alert(XSS attack)</script>", attached {READABLE_STRING_8} sec.custom_http_expect (req, {ARRAY [REGULAR_EXPRESSION]}<<l_protection.xss_javascript_expression>>) as v and then v.is_empty )
		end

	test_http_referer_attack_with_xss_js_protection_fails
		local
			req: WSF_REQUEST
			sec: WSF_PROTECTION_POLICY
			l_protection: WSF_PROTECTION_PATTERNS
			l_str: STRING
		do
			l_str:= "[
				Referer: http://www.google.com/search?hl=en&q=fe525"-alert(1)-"d116a885fd5
				]"
			create sec
			--| Case HTTP header referer attack, filtered using {xss_javascript_expression}
			req := new_request (<<
						["REQUEST_METHOD", "GET"],
						["QUERY_STRING", ""],
						["REQUEST_URI", "/xss_example"],
						["HTTP_REFERER", l_str]
					>>
				)
			assert ("HTTP_REFERER", attached {READABLE_STRING_8} sec.custom_http_referer (req, {ARRAY [REGULAR_EXPRESSION]}<<l_protection.xss_javascript_expression>>) as v and then not v.is_empty )
		end


	test_http_referer_attack_with_xss_protection
		local
			req: WSF_REQUEST
			sec: WSF_PROTECTION_POLICY
			l_protection: WSF_PROTECTION_PATTERNS
			l_str: STRING
		do
			l_str:= "[
				Referer: http://www.google.com/search?hl=en&q=fe525"-alert(1)-"d116a885fd5
				]"
			create sec
			--| Case HTTP header referer attack, filtered using {xss_javascript_expression}
			req := new_request (<<
						["REQUEST_METHOD", "GET"],
						["QUERY_STRING", ""],
						["REQUEST_URI", "/xss_example"],
						["HTTP_REFERER", l_str]
					>>
				)
			assert ("HTTP_REFERER", attached {READABLE_STRING_8} sec.custom_http_referer (req, {ARRAY [REGULAR_EXPRESSION]}<<l_protection.xss_regular_expression>>) as v and then not v.is_empty )
		end


feature {NONE} -- Implementation

	new_request (a_meta: ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]]): WSF_REQUEST_NULL
		local
			wgi_req: WGI_REQUEST
		do
			create {WGI_REQUEST_NULL} wgi_req.make_with_file (a_meta, io.input)
			create Result.make_from_wgi (wgi_req)
		end

end
