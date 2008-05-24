indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature -- Initialization

	make is
			-- Run application.
		do
			print ("JSON OBJECT%N")
			test_json_object

			print ("%NJSON STRING%N")
			test_json_string

			print ("%NJSON NUMBER%N")
			test_json_number

			print ("%NJSON NULL%N")
			test_json_null

			print ("%NJSON BOOLEAN%N")
			test_json_boolean

			print ("%NJSON ARRAY%N")
			test_json_array

			print ("%NJSON READER%N")
			test_json_reader

			print ("%NJSON PARSER%N")
			test_json_parser

		end

	test_json_object is
			--
			local
							jo:JSON_OBJECT
			do
				create jo.make
				jo.put (create {JSON_STRING}.make_json("myKey"), create {JSON_STRING}.make_json ("MyValue"))
				print (jo.to_json)
			end

	test_json_string is
			--
			local
				js:JSON_STRING
			do
				create js.make_json ("Json String example")
				print (js.to_json)
			end

	test_json_number is
			--
			local
				jnr,jni:JSON_NUMBER
			do
				create jnr.make_real (12.3)
				print (jnr.to_json)
				print ("%N")
				create jni.make_integer (123)
				print (jni.to_json)


			end


	 test_json_null is
			--
			local
				jnull:JSON_NULL
			do

				create jnull
				print (jnull.to_json)

			end

	test_json_boolean is
			--
			local
				jbt,jbf:JSON_BOOLEAN
			do
				create jbt.make_boolean (true)
				print (jbt.to_json)

				print ("%N")
				create jbf.make_boolean (false)
				print (jbf.to_json)

			end


	test_json_array is
			--
			local
				ja:JSON_ARRAY

				jo: JSON_OBJECT
			do
				create ja.make_array
				ja.add (create{JSON_STRING}.make_json ("valor1"))
				ja.add (create{JSON_NUMBER}.make_integer (10))
				ja.add (create{JSON_NULL} )
				ja.add (create{JSON_BOOLEAN}.make_boolean (true))

				create jo.make
				jo.put (create {JSON_STRING}.make_json("myKey"), create {JSON_STRING}.make_json ("MyValue"))

				ja.add (jo)
				print (ja.to_json)

			end

	test_json_reader is
			--
			local
			     jr:EXAMPLE_JSON_READER
			do
                 create jr.make
                 jr.test_create_reader
			end

   	test_json_parser is
			--
			local
			     jp:EXAMPLE_JSON_PARSER
			do
                 create jp
                 print("%N ARRAY PARSING %N")
                 jp.test_json_array

                 print("%N GLOSSATY PARSING %N")
                 jp.test_json_glossary_from_file

                 print("%N NUMBER PARSING %N")
                 jp.test_json_number

                 print("%N OBJECTS PARSING %N")
                 jp.test_json_objects_with_string

                 print("%N STRING PARSING %N")
                 jp.test_json_string




			end




end -- class APPLICATION
