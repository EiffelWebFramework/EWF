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

feature -- Helpers

	format (a_common: COMMON_RESULTS): STRING
			-- Representation of the current object
		do
			create Result.make_from_string ("(")
			if attached a_common.field as t then
				Result.append_string ("'" + t + "',")
			end
			Result.append_string (" {")
			from
				a_common.params.start
			until
				a_common.params.after
			loop
				Result.append ("'" + a_common.params.key_for_iteration + "':'" + a_common.params.item_for_iteration + "',");
				a_common.params.forth
			end
			Result.append ("})")
		end


feature -- Test routines

	test_parse_charsets
		do
			assert ("Expected ('iso-8859-5', {'q':'1.0',})", format (parser.parse_common("iso-8859-5")).same_string("('iso-8859-5', {'q':'1.0',})") )
			assert ("Expected ('unicode-1-1', {'q':'0.8',})", format (parser.parse_common("unicode-1-1;q=0.8")).same_string("('unicode-1-1', {'q':'0.8',})") )
			assert ("Expected ('*', {'q':'1.0',})", format (parser.parse_common("*")).same_string("('*', {'q':'1.0',})") )
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
