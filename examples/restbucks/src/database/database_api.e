note
	description: "Summary description for {DATABASE_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE_API
create
	make

feature --Initialization
	make
		do
			create orders.make (10)
		end

feature -- Access
	orders : HASH_TABLE[ORDER,STRING]

end
