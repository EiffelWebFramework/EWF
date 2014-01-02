note
	description: "Summary description for {WSF_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE

create
	make

feature {NONE}

	make (a_name, a_type: STRING; a_size: INTEGER; a_id: detachable STRING)
		do
			name := a_name
			type := a_type
			size := a_size
			id := a_id
		end

feature

	set_id (a_id: detachable STRING)
		do
			id := a_id
		end

feature --Properties

	is_uploaded: BOOLEAN
		do
			Result := attached id
		end

	name: STRING
			-- File name

	type: STRING
			-- File mime type

	size: INTEGER
			-- File size

	id: detachable STRING
			-- Server side file id (e.g. S3 filename)

end
