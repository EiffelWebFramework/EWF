indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_JSON_READER

create
	make
feature -- Access
	make is
			--
			do
				test_create_reader
			end

	test_create_reader is
			--
			local
				reader:JSON_READER
				condition:BOOLEAN
			do
				create reader.make("{%"key%":%"value%"}")

				from
					condition:=false
				until condition

				loop
					if reader.has_next then
						print (reader.read)
						reader.next
					else
						condition:=true
					end
				end
			end

end
