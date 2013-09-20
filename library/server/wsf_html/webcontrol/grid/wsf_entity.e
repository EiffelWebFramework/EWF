note
	description: "Summary description for {WSF_ENTITY}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_ENTITY

feature -- Access

	item (a_field: READABLE_STRING_GENERAL): detachable ANY
			-- Value for field item `a_field'.
		deferred
		end

end
