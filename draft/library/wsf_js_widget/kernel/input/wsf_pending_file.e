note
	description: "Summary description for {WSF_PENDING_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PENDING_FILE

create
	make

feature {NONE}

	make (a_name, a_type: STRING; a_size: INTEGER)
		do
			name := a_name
			type := a_type
			size := a_size
		end

feature --Properties

	name: STRING

	type: STRING

	size: INTEGER

end
