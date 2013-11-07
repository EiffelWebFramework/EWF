note
	description: "Summary description for {WSF_NAVLIST_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVLIST_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_NAVLIST_ITEM_CONTROL]
		rename
			make as make_multi_control
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_multi_control
			add_class ("list-group")
		end

feature -- Change

	add_link (link, text: STRING)
		local
			c: WSF_NAVLIST_ITEM_CONTROL
		do
			create c.make (link, text)
			add_control(c)
		end

	add_button (event:attached like {WSF_BUTTON_CONTROL}.click_event; text: STRING)
		local
			c: WSF_NAVLIST_ITEM_CONTROL
		do
			create c.make ("", text)
			c.set_click_event(event)
			add_control(c)
		end

end
