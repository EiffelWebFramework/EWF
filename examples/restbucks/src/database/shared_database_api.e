note
	description: "Summary description for {SHARED_DATABASE_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_DATABASE_API
feature
	db_access: DATABASE_API
		once
			create Result.make
		end
end
