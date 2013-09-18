note
	description: "Summary description for {WSF_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_ENTITY

feature

	get (field: STRING): detachable ANY
		deferred
		end

end
