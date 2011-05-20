note
	description: "Summary description for {SHARED_DOCUMENT_ROOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_DOCUMENT_ROOT
feature

	document_root_cell: CELL [STRING]
		once ("PROCESS")
			create Result.put (Void)
		end

end
