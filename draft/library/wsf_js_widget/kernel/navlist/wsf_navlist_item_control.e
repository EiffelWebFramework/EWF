note
	description: "[
		WSF_NAVLIST_ITEM_CONTROL represents a menu item in WSF_NAVLIST_CONTROL
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVLIST_ITEM_CONTROL

inherit

	WSF_BUTTON_CONTROL
		rename
			make as make_button
		redefine
			set_state,
			state
		end

create
	make

feature {NONE} -- Initialization

	make (link, t: STRING)
		do
			make_control ("a")
			text := t
			attributes := "href=%"" + link + "%"";
			add_class ("list-group-item")
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore text and active state from json
		do
			Precursor {WSF_BUTTON_CONTROL} (new_state)
			if attached {JSON_BOOLEAN} new_state.item ("active") as new_active then
				active := new_active.item
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current text, if the control is active and if there is an event handle attached
		do
			Result := Precursor {WSF_BUTTON_CONTROL}
			Result.put_boolean (active, "active")
		end

feature -- Change

	set_active (a: BOOLEAN)
			-- Set text of that button
		do
			if active /= a then
				active := a
				if a then
					add_class ("active")
				else
					remove_class ("active")
				end
				state_changes.replace (create {JSON_BOOLEAN}.make_boolean (a), "active")
			end
		end

feature -- Properties

	active: BOOLEAN

end
