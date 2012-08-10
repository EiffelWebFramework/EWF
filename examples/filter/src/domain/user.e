note
	description: "User."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER

create
	make

feature {NONE} -- Initialization

	make (an_id: INTEGER; a_name, a_password: STRING)
		do
			id := an_id
			name := a_name
			password := a_password
		ensure
			id_set: id = an_id
			name_set: name = a_name
			password_set: password = a_password
		end

feature -- Access

	id: INTEGER
			-- Identifier

 	name: STRING
 			-- Name

 	password: STRING
 			-- Password

;note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
