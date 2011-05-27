note
	description: "Summary description for {SHARED_URI_CONTENTS_TYPES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_URI_CONTENTS_TYPES
feature

	ct_table: URI_CONTENTS_TYPES 
		once
			create Result.make
		end
end
