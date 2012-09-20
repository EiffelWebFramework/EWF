note
	description: "Summary description for {DATABASE_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE_API
create
	make

feature -- Initialization

	make
		local
			l_user: USER
		do
			create users.make (10)
			create l_user.make (1, "foo", "bar")
			users.put (l_user, l_user.id)
		end

feature -- Access

	users: HASH_TABLE [USER, INTEGER]

;note
	copyright: "2011-2011, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
