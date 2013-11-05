note
	description: "Summary description for {WSF_NAVLIST_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVLIST_ITEM

inherit

	WSF_BUTTON_CONTROL
		rename
			make as make_button
		end

create
	make

feature {NONE} -- Initialization

	make (n, t: STRING)
		do
			make_control (n, "a")
			text := t
		end

end
