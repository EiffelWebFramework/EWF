note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	HTTP_DATE_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_http_date
			-- New test routine
		local
			s: STRING
			d: HTTP_DATE
		do
			s := "Sun, 06 Nov 1994 08:49:37 GMT"
			create d.make_from_string (s)
			assert ("RFC 1123", not d.has_error and then d.string.same_string (s))
			create d.make_from_timestamp (d.timestamp)
			assert ("RFC 1123", not d.has_error and then d.string.same_string (s))

			s := "Sunday, 06-Nov-94 08:49:37 GMT"
			create d.make_from_string (s)
			assert ("RFC 850", not d.has_error and then d.rfc850_string.same_string (s))
			create d.make_from_timestamp (d.timestamp)
			assert ("RFC 850", not d.has_error and then d.rfc850_string.same_string (s))


			s := "Sun Nov  6 08:49:37 1994"
			create d.make_from_string (s)
			assert ("ANSI format", d.has_error)



			-- Tolerance ...
			s := "Sun, 06 Nov 1994 09:49:37 GMT+1"

			create d.make_from_string (s)
			assert ("RFC 1123", not d.has_error and then d.string.same_string ("Sun, 06 Nov 1994 08:49:37 GMT"))


		end

end
