indexing
	description:
		"[
			This class contains test cases. 
                     TODO: Put proper description of class here.
			Visit http://dev.eiffel.com/CddBranch for more information.
		]"
	author: "EiffelStudio CDD Tool"
	date: "$Date$"
	revision: "$Revision$"
	cdd_id: "6BDE677C-83F4-4406-B846-BCF548A8E6C4"

class
	TEST_JSON_SUITE

inherit
	CDD_TEST_CASE

feature -- Tests Pass

	test_json_pass1 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/pass1.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("pass1.json",parse_json.is_parsed)
    		end

	test_json_pass2 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/pass2.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_true ("pass2.json",parse_json.is_parsed)
    		end

    test_json_pass3 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/pass3.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_true ("pass3.json",parse_json.is_parsed)
    		end

feature -- Tests Failures
    test_json_fail1 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail1.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_true ("fail1.json",parse_json.is_parsed)
    		end

    test_json_fail2 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail2.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail2.json",parse_json.is_parsed)
    		end

	test_json_fail3 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail3.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail3.json",parse_json.is_parsed)
    		end

	test_json_fail4 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail4.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail4.json",parse_json.is_parsed)
    		end

    test_json_fail5 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail5.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail5.json",parse_json.is_parsed)
    		end


	test_json_fail6 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail6.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail6.json",parse_json.is_parsed)
    		end

 	test_json_fail7 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail7.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail7.json",parse_json.is_parsed)
    		end

  	test_json_fail8 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail8.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail8.json",parse_json.is_parsed)
    		end


	test_json_fail9 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail9.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail9.json",parse_json.is_parsed)
    		end


	test_json_fail10 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail10.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail10.json",parse_json.is_parsed)
    		end

   	test_json_fail11 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail11.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail11.json",parse_json.is_parsed)
    		end

	test_json_fail12 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail12.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail12.json",parse_json.is_parsed)
    		end

    test_json_fail13 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail13.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail13.json",parse_json.is_parsed)
    		end

  	test_json_fail14 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail14.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail14.json",parse_json.is_parsed)
    		end

	test_json_fail15 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail15.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail15.json",parse_json.is_parsed)
    		end

	test_json_fail16 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail16.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail16.json",parse_json.is_parsed)
    		end

	test_json_fail17 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail17.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail17.json",parse_json.is_parsed)
    		end

	test_json_fail18 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail18.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail18.json",parse_json.is_parsed)
    		end

	test_json_fail19 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail19.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail19.json",parse_json.is_parsed)
    		end

	test_json_fail20 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail20.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail20.json",parse_json.is_parsed)
    		end

    test_json_fail21 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail21.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail21.json",parse_json.is_parsed)
    		end


 	test_json_fail22 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail22.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail22.json",parse_json.is_parsed)
    		end

    test_json_fail23 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail23.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail23.json",parse_json.is_parsed)
    		end

 	test_json_fail24 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail24.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail24.json",parse_json.is_parsed)
    		end

	test_json_fail25 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail25.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail25.json",parse_json.is_parsed)
    		end


   	test_json_fail26 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail26.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail26.json",parse_json.is_parsed)
    		end


   	test_json_fail27 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail27.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse_json
		  			assert_false ("fail27.json",parse_json.is_parsed)
    		end


   	test_json_fail28 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail28.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail28.json",parse_json.is_parsed)
    		end


   	test_json_fail29 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail29.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail29.json",parse_json.is_parsed)
    		end


   	test_json_fail30 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail30.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail30.json",parse_json.is_parsed)
    		end

	test_json_fail31 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail31.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail31.json",parse_json.is_parsed)
    		end

    test_json_fail32 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail32.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail32.json",parse_json.is_parsed)
    		end

    test_json_fail33 is
    		--
    		do
    				create file_reader
    				json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/cdd_tests/json_test/fail33.json")
					create parse_json.make_parser (json_file)
					json_value := parse_json.parse
		  			assert_false ("fail33.json",parse_json.is_parsed)
    		end
feature -- JSON_FROM_FILE
   	json_file:STRING
   	parse_json:JSON_PARSER
 	json_object:JSON_OBJECT
	file_reader:JSON_FILE_READER
	json_value : JSON_VALUE
end
