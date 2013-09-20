note
	description: "Summary description for {WSF_PASSWORD_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PASSWORD_CONTROL

inherit

	WSF_INPUT_CONTROL

create
	make_password

feature {NONE}

	make_password (n: STRING; v: STRING)
		do
			make_input (n, v)
			type := "password"
		end

end
