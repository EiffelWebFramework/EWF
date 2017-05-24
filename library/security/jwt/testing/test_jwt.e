note
	description: "Summary description for {TEST_JWT}."
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_JWT

inherit
	EQA_TEST_SET

feature -- Test

	test_jwt_io
		local
			jwt: JWT
			header: STRING
			payload: STRING
		do
			payload := "[
					{"sub":"1234567890","name":"John Doe","admin":true}
				]"
			payload.adjust
			payload.replace_substring_all ("%N", "%R%N")

			create jwt

			assert ("header", jwt.base64url_encode (jwt.header (Void, "HS256")).same_string ("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"))
			assert ("payload", jwt.base64url_encode (payload).same_string ("eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9"))
			assert ("signature", jwt.encoded_string (payload, "secret", "HS256").same_string ("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.pcHcZspUvuiqIPVB_i_qmcvCJv63KLUgIAKIlXI1gY8"))
		end

	test_jwt
		local
			jwt: JWT
			payload: STRING
			tok: STRING
		do
			payload := "[
				{"iss":"joe",
				 "exp":1300819380,
				 "http://example.com/is_root":true}
				]"

--			payload := "[
--					{"sub":"1234567890","name":"John Doe","admin":true}
--				]"

			create jwt
			tok := jwt.encoded_string (payload, "secret", "HS256")

			if attached jwt.decoded_string (tok, "secret", Void) as l_tok_payload then
				assert ("no error", not jwt.has_error)
				assert ("same payload", l_tok_payload.same_string (payload))
			end
		end

	test_unsecured_jwt
		local
			jwt: JWT
			payload: STRING
			tok: STRING
		do
			payload := "[
				{"iss":"joe",
				 "exp":1300819380,
				 "http://example.com/is_root":true}
				]"

			create jwt
			tok := jwt.encoded_string (payload, "secret", "none")

			if attached jwt.decoded_string (tok, "secret", Void) as l_tok_payload then
				assert ("no error", not jwt.has_error)
				assert ("same payload", l_tok_payload.same_string (payload))
			end
		end

end
