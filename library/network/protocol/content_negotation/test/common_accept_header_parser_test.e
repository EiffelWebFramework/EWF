note
	description: "Summary description for {COMMON_ACCEPT_HEADER_PARSER_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMON_ACCEPT_HEADER_PARSER_TEST

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
			-- Called after all initializations in `default_create'.
		do
			create parser
		end

feature -- Test routines

	test_parse_charsets
		do
			assert ("Expected ('iso-8859-5', {'q':'1.0',})", parser.parse_common("iso-8859-5").out.same_string("('iso-8859-5', {'q':'1.0',})") )
			assert ("Expected ('unicode-1-1', {'q':'0.8',})", parser.parse_common("unicode-1-1;q=0.8").out.same_string("('unicode-1-1', {'q':'0.8',})") )
			assert ("Expected ('*', {'q':'1.0',})", parser.parse_common("*").out.same_string("('*', {'q':'1.0',})") )
		end


	test_quality_example
		local
			accept : STRING
		do
			accept := "iso-8859-5, unicode-1-1;q=0.8";
			assert ("Expected 1.0", 1.0 = parser.quality ("iso-8859-5", accept))
			assert ("Expected 0.8", 0.8 = parser.quality ("unicode-1-1", accept))
		end


	test_best_match
		local
			charset_supported : LIST [STRING]
			l_charsets : STRING
		do
			l_charsets := "iso-8859-5, unicode-1-1;q=0.8"
			charset_supported := l_charsets.split(',')
			assert ("Expected iso-8859-5", parser.best_match (charset_supported, "*").same_string ("iso-8859-5"))
			assert ("Expected unicode-1-1", parser.best_match (charset_supported, "unicode-1-1;q=1").same_string ("unicode-1-1"))
		end

	parser : COMMON_ACCEPT_HEADER_PARSER

end
