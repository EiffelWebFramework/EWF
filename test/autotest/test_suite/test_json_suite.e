note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_JSON_SUITE

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			create file_reader
		end


feature -- Tests Pass

	test_json_pass1 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir + "pass1.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("pass1.json",parse_json.is_parsed = True)
    		end

	test_json_pass2 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"pass2.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("pass2.json",parse_json.is_parsed = True)
    		end

    test_json_pass3 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"pass3.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("pass3.json",parse_json.is_parsed = True)
    		end

feature -- Tests Failures
    test_json_fail1 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail1.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail1.json",parse_json.is_parsed = False)
    		end

    test_json_fail2 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail2.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail2.json",parse_json.is_parsed = False)
    		end

	test_json_fail3 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail3.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail3.json",parse_json.is_parsed = False)
    		end

	test_json_fail4 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail4.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail4.json",parse_json.is_parsed = False)
    		end

    test_json_fail5 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail5.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail5.json",parse_json.is_parsed = False)
    		end


	test_json_fail6 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail6.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail6.json",parse_json.is_parsed = False )
    		end

 	test_json_fail7 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail7.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail7.json",parse_json.is_parsed = False)
    		end

  	test_json_fail8 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail8.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail8.json",parse_json.is_parsed = False )
    		end


	test_json_fail9 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail9.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail9.json",parse_json.is_parsed = False)
    		end


	test_json_fail10 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail10.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail10.json",parse_json.is_parsed = False)
    		end

   	test_json_fail11 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail11.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail11.json",parse_json.is_parsed = False)
    		end

	test_json_fail12 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail12.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail12.json",parse_json.is_parsed = False)
    		end

    test_json_fail13 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail13.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail13.json",parse_json.is_parsed = False)
    		end

  	test_json_fail14 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail14.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail14.json",parse_json.is_parsed = False)
    		end

	test_json_fail15 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail15.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail15.json",parse_json.is_parsed = False)
    		end

	test_json_fail16 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail16.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail16.json",parse_json.is_parsed = False)
    		end

	test_json_fail17 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail17.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail17.json",parse_json.is_parsed = False)
    		end

	test_json_fail18 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail18.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail18.json",parse_json.is_parsed = True)
    		end

	test_json_fail19 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail19.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail19.json",parse_json.is_parsed = False)
    		end

	test_json_fail20 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail20.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail20.json",parse_json.is_parsed = False)
    		end

    test_json_fail21 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail21.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail21.json",parse_json.is_parsed = False)
    		end


 	test_json_fail22 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail22.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail22.json",parse_json.is_parsed = False)
    		end

    test_json_fail23 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail23.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail23.json",parse_json.is_parsed = False)
    		end

 	test_json_fail24 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail24.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail24.json",parse_json.is_parsed = False)
    		end

	test_json_fail25 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail25.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail25.json",parse_json.is_parsed = False)
    		end


   	test_json_fail26 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail26.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail26.json",parse_json.is_parsed = False)
    		end


   	test_json_fail27 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail27.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail27.json",parse_json.is_parsed = False)
    		end


   	test_json_fail28 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail28.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail28.json",parse_json.is_parsed = False)
    		end


   	test_json_fail29 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail29.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail29.json",parse_json.is_parsed = False )
    		end


   	test_json_fail30 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail30.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail30.json",parse_json.is_parsed = False)
    		end

	test_json_fail31 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail31.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail31.json",parse_json.is_parsed = False)
    		end

    test_json_fail32 is
    		--
    		do
    			json_file:=file_reader.read_json_from (test_dir +"fail32.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail32.json",parse_json.is_parsed = False)
    		end

    test_json_fail33 is
    		--
    		do
				json_file:=file_reader.read_json_from (test_dir +"fail33.json")
				create parse_json.make_parser (json_file)
				json_value := parse_json.parse_json
		  		assert ("fail33.json",parse_json.is_parsed = False)
    		end
feature -- JSON_FROM_FILE

	json_file:STRING
	parse_json:JSON_PARSER
	json_object:JSON_OBJECT
	file_reader:JSON_FILE_READER
	json_value : JSON_VALUE
	test_dir : STRING is "/home/jvelilla/work/project/Eiffel/ejson_dev/trunk/test/autotest/test_suite/"

end


