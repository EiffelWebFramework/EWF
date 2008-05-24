indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_JSON_PARSER

feature -- Access

	test_json_string is
			--
			local
				parse_json:JSON_PARSER
				json_value:JSON_VALUE
			do
				create parse_json.make_parser("%"key %N This is a test %"")
				json_value:=parse_json.parse
				print (json_value.to_json)
			end

	test_json_objects_with_string is
			--
			local
				parse_json:JSON_PARSER
				json_value:JSON_VALUE
			do
				create parse_json.make_parser("{}")
				json_value:=parse_json.parse
				print (json_value.to_json)

				create parse_json.make_parser("{%"key%":%"value%"}")
				json_value:=parse_json.parse
				print (json_value.to_json)


				create parse_json.make_parser("{%"key%"   :%"value%"}")
				json_value:=parse_json.parse
				print (json_value.to_json)


				create parse_json.make_parser("{%"key%"   :     %"value%"}")
				json_value:=parse_json.parse
				print (json_value.to_json)


				create parse_json.make_parser("{%"key%"   :     %"value%"    }")
				json_value:=parse_json.parse
				print (json_value.to_json)


				create parse_json.make_parser("{   %N%"key%"   :     %"value%"    }")
				json_value:=parse_json.parse
				print (json_value.to_json)


				create parse_json.make_parser("{   %N%"key%"   ;     %"value%"    }")
				json_value:=parse_json.parse
				print (json_value.to_json)

			end

	test_json_array is
			--
			local
				parse_json:JSON_PARSER
				json_value:JSON_VALUE
			do
				create parse_json.make_parser ("[]")
				json_value:=parse_json.parse
				print (json_value.to_json)


				create parse_json.make_parser ("[%"value%"]")
				json_value:=parse_json.parse
				print (json_value.to_json)

				create parse_json.make_parser ("[%"value%",%"value2%"]")
				json_value:=parse_json.parse
				print (json_value.to_json)

				--create parse_json.make_parser ("[%"value%";%"value2%"]")
				--json_value:=parse_json.parse
				--print (json_value.to_json)


				create parse_json.make_parser ("[null]")
				json_value:=parse_json.parse
				print (json_value.to_json)

				create parse_json.make_parser ("[false]")
				json_value:=parse_json.parse
				print (json_value.to_json)

				create parse_json.make_parser ("[true]")
				json_value:=parse_json.parse
				print (json_value.to_json)

			end

	test_json_number is
			--
			local
				parse_json:JSON_PARSER
				json_value:JSON_VALUE
			do
				create parse_json.make_parser ("1234.5")
				json_value:=parse_json.parse
				print (json_value.to_json)


			    create parse_json.make_parser ("1234.e5")
				json_value:=parse_json.parse
				print (json_value.to_json)
			end

	test_json_glossary_from_file is
			--
			local
				file_reader:JSON_FILE_READER
	        	parse_json:JSON_PARSER
				json_value:JSON_VALUE

	        do

	        	create file_reader
	            create parse_json.make_parser (file_reader.read_json_from ("./json_glossary_example.txt"))
				json_value:=parse_json.parse
				print (json_value.to_json)


				print ("%N JSON MENU %N")
	            create parse_json.make_parser (file_reader.read_json_from ("./json_menu_example.txt"))
				json_value:=parse_json.parse
				print (json_value.to_json)

				print ("%N JSON WIDGET %N")
				create parse_json.make_parser (file_reader.read_json_from ("./json_widget_example.txt"))
				json_value:=parse_json.parse
				print (json_value.to_json)


				print ("%N JSON WEBXML %N")
				create parse_json.make_parser (file_reader.read_json_from ("./json_webxml_example.txt"))
				json_value:=parse_json.parse
				print (json_value.to_json)

				print ("%N JSON MENU2 %N")
				create parse_json.make_parser (file_reader.read_json_from ("./json_menu2_example.txt"))
				json_value:=parse_json.parse
				print (json_value.to_json)




	        end


end
