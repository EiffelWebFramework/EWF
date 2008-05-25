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

		do
			create file_reader
			json_file:=file_reader.read_json_from ("/home/jvelilla/work/eiffel_work/json_test/json_menu_example.txt")
			create parse_json.make_parser (json_file)
			json_value := parse_json.parse
			json_object ?= json_value
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

    test_has_item is
    	do
    		print (json_object.item (create {JSON_STRING}.make_json ("menu")))

    	end

	test_json_value is
			--
		do
			assert_true ("Is a JSON_OBJECT",json_object.is_json_object)
		end

	test_conversion_to_json_object is
			--
			local
			  jo:JSON_OBJECT
			do
				jo:=json_value.to_json_object
				assert ("Is a JSON_OBJECT",jo.has_key (create {JSON_STRING}.make_json ("menu")))
			end

    test_json_objects_items is
    		--
    		local
    			jo:JSON_OBJECT

    		do
    			jo:=json_value.to_json_object
    			json_value:=jo.item (create {JSON_STRING}.make_json ("menu"))
				jo:=json_value.to_json_object
				assert_true ("Has key id",jo.has_key (create {JSON_STRING}.make_json ("id")))
				assert_true ("Has key value",jo.has_key (create {JSON_STRING}.make_json ("value")))
				assert_true ("Has key popup",jo.has_key (create {JSON_STRING}.make_json ("popup")))
				assert_true ("Item with key id is a JSON_STRING",jo.item (create{JSON_STRING}.make_json ("id")).is_json_string)
				assert_true ("Item with key value is a JSON_STRING",jo.item (create{JSON_STRING}.make_json ("value")).is_json_string)
				assert_true ("Item with key popup is a JSON_OBJECT",jo.item (create{JSON_STRING}.make_json ("popup")).is_json_object)

				json_value:=jo.item (create{JSON_STRING}.make_json ("popup"))
				jo:=json_value.to_json_object
				assert_true ("Has key menuitem",jo.has_key (create {JSON_STRING}.make_json ("menuitem")))
				assert_true ("Item with key menuitem is a JSON_ARRAY",jo.item (create{JSON_STRING}.make_json ("menuitem")).is_json_array)

    		end



feature -- JSON_FROM_FILE
   	json_file:STRING
   	parse_json:JSON_PARSER
 	json_object:JSON_OBJECT
	file_reader:JSON_FILE_READER
	json_value : JSON_VALUE
end

