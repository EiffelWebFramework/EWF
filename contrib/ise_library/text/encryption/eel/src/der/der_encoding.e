note
	description: "Summary description for {DER_ENCODING}."
	author: ""
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"

class
	DER_ENCODING

inherit
	DEVELOPER_EXCEPTION

create
	make

feature
	make (reason_a: STRING)
		do
			reason := reason_a
		end

feature
	reason: STRING
end
