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
	cdd_id: "EC96DF4F-CBC1-42B3-A9B2-13FC6BBF1C54"

class
	TEST_JSON_OBJECTS

inherit

	CDD_TEST_CASE
		redefine
			set_up
		end

feature -- Basic operations
	set_up is
			-- Setup test case. Called by test harness
			-- before each test routine invocation. Redefine
			-- this routine in descendants.
		local
			file_reader:JSON_FILE_READER
		do
			create file_reader
			json_file:=file_reader.read_json_from ("./json_menu_example.txt")
			create parse_json.make_parser (json_file)
			json_object ?= parse_json.parse
		end
feature -- Tests

	test_has_key is
		do
			assert_true ("Has the key menu",json_object.has_key (create {JSON_STRING}.make_json ("menu")))
		end

	test_has_not_key is
		do
			assert_false ("Not Has the key test",json_object.has_key (create {JSON_STRING}.make_json ("test")))
		end

	test_current_keys is
		do
            assert_integers_equal ("Has 1 key", 1, json_object.get_keys.count)
		end

feature -- JSON_FROM_FILE
   	json_file:STRING
   	parse_json:JSON_PARSER
 	json_object:JSON_OBJECT

end

