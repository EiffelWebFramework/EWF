note
	description: "Summary description for {LANGUAGE_PARSER_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_PARSER_TEST

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

	test_parse_media_range
		do
			assert ("Expected ('da', {'q':'1.0',})", parser.parse_language_range ("da").out.same_string ("('da', {'q':'1.0',})"));
			assert ("Expected ('en', 'gb', {'q':'0.8',})", parser.parse_language_range ("en-gb;q=0.8").out.same_string ("('en', 'gb', {'q':'0.8',})"));
			assert ("Expected ('en', {'q':'0.7',})", parser.parse_language_range ("en;q=0.7").out.same_string ("('en', {'q':'0.7',})"));
			assert ("Expected ('en', '*', {'q':'1.0',})", parser.parse_language_range ("en-*").out.same_string ("('en', '*', {'q':'1.0',})"));
		end


	test_RFC2616_example
		local
			accept : STRING
		do
			accept := "da, en-gb;q=0.8, en;q=0.7";
			assert ("Expected 1.0", 1.0 = parser.quality ("da", accept))
			assert ("Expected 0.8", 0.8 = parser.quality ("en-gb", accept))
			assert ("Expected 0.8", 0.8 = parser.quality ("en", accept))
			assert ("Expected 0.8", 0.8 = parser.quality ("en-*", accept))
		end


	test_best_match
		local
			mime_types_supported : LIST [STRING]
			l_types : STRING
		do
			l_types := "en-gb,en-us"
			mime_types_supported := l_types.split(',')
			assert ("Expected en-us", parser.best_match (mime_types_supported, "en-us").same_string ("en-us"))
			assert ("Direct match with a q parameter", parser.best_match (mime_types_supported, "en-gb;q=1").same_string ("en-gb"))
			assert ("Direct match second choice with a q parameter", parser.best_match (mime_types_supported, "en-us;q=1").same_string ("en-us"))
			assert ("Direct match using a subtype wildcard", parser.best_match (mime_types_supported, "en-*;q=1").is_equal ("en-gb"))
			assert ("Match using a type wildcard", parser.best_match (mime_types_supported, "*").same_string ("en-gb"))

			l_types := "en-gb,es"
			mime_types_supported := l_types.split(',')
			assert ("Match using a type versus a lower weighted subtype", parser.best_match (mime_types_supported, "es-*;q=0.5,*;q=0.1").same_string ("es"))
			assert ("Fail to match anything",parser.best_match (mime_types_supported, "fr; q=0.9").same_string (""))

			l_types := "en-gb,en-us"
			mime_types_supported := l_types.split(',')
			assert ("Test 1 verify fitness ordering", parser.best_match (mime_types_supported, "en-gb,en-us,*").same_string ("en-gb"))

			l_types := "es,en-gb;q=1.0,fr;q=0.6"
			mime_types_supported := l_types.split(',')
			assert ("Match default es at first position", parser.best_match (mime_types_supported, "es;q=1.0,*;q=0.1,fr").same_string ("es"))

			l_types := "en-gb;q=1.0,fr;q=0.6,es"
			mime_types_supported := l_types.split(',')
			assert ("Match default es at last position", parser.best_match (mime_types_supported, "es;q=1.0,*;q=0.1,fr").same_string ("es"))

			l_types := "en-gb;q=1.0,fr,es"
			mime_types_supported := l_types.split(',')
			assert ("Match first top quality and fitness", parser.best_match (mime_types_supported, "es;q=1.0,*;q=0.1,fr").same_string ("es"))

			l_types := "fr;q=1.0,en,es"
			mime_types_supported := l_types.split(',')
			assert ("Test 1", parser.best_match (mime_types_supported, "es;q=1.0,*/*;q=0.1,en;q=0.9").same_string ("es"))

			l_types := "fr;q=1.0,en,es"
			mime_types_supported := l_types.split(',')
			assert ("Test 1", parser.best_match (mime_types_supported, "es,*/*;q=0.1,en").same_string ("es"))

			l_types := "fr;q=1.0,en,es"
			mime_types_supported := l_types.split(',')
			assert ("Test 2", parser.best_match (mime_types_supported, "en,es,*/*;q=0.1").same_string ("en"))

			l_types := "es,en;q=0.6"
			mime_types_supported := l_types.split(',')
			assert ("Test 2", parser.best_match (mime_types_supported, "fr;q=1.0, en;q=0.6, es").same_string ("es"))

		end


	test_support_wildcard
		local
			mime_types_supported : LIST[STRING]
			l_types : STRING
		do
			l_types := "en-*,fr"
			mime_types_supported := l_types.split(',')
			assert ("match using a type wildcard", parser.best_match (mime_types_supported, "en-gb").same_string ("en-*"))
		end




	parser : LANGUAGE_PARSE

end


