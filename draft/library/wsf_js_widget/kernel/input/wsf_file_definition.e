note
	description: "Summary description for {WSF_FILE_DEFINITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE_DEFINITION

create
	make

feature {NONE}

	make (a_name, a_type: STRING_32; a_size: INTEGER; a_id: detachable STRING_32)
		do
			name := a_name
			type := a_type
			size := a_size
			id := a_id
		end

feature

	set_id (a_id: detachable STRING_32)
		do
			id := a_id
		end

feature --Properties

	is_uploaded: BOOLEAN
		do
			Result := attached id
		end

	name: STRING_32
			-- File name

	type: STRING_32
			-- File mime type

	size: INTEGER
			-- File size

	id: detachable STRING_32
			-- Server side file id (e.g. S3 filename)

end
