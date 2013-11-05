note
	description: "Summary description for {WSF_NAVLIST_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVLIST_ITEM_CONTROL

inherit

	WSF_BUTTON_CONTROL
		rename
			make as make_button
		end

create
	make

feature {NONE} -- Initialization

	make (n, link, t: STRING)
		do
			make_control (n, "a")
			text := t
			attributes := "href=%"" + link + "%"";
			add_class ("list-group-item")
		end

end
