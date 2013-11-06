note
	description: "Summary description for {WSF_STATELESS_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STATELESS_MULTI_CONTROL [G -> WSF_STATELESS_CONTROL]
inherit
	WSF_MULTI_CONTROL [G]
		rename
			make_with_tag_name as make_with_tag_name_and_name
		end

create
	make_with_tag_name, make_tag_less

feature {NONE} -- Initialization

	make_with_tag_name(t:STRING)
	do
		make_with_tag_name_and_name("",t)
	end

	make_tag_less
		do
			make_with_tag_name_and_name ("", "")
			stateless := True
		end

end
