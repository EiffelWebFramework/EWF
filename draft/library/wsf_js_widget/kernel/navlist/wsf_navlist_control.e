note
	description: "Summary description for {WSF_NAVLIST_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVLIST_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control
		end

create
	make

feature {NONE} -- Initialization

	make (n: STRING)
		do
			make_multi_control (n)
			add_class ("list-group")
		end

feature -- Change

	add_link (link, text: STRING)
		local
			c: WSF_NAVLIST_ITEM_CONTROL
		do
			create c.make (control_name + "_item_" + controls.count.out, link, text)
		end

end
