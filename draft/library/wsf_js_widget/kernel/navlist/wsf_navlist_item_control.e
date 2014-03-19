note
	description: "[
		This class represents a menu item in WSF_NAVLIST_CONTROL.
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

	make (link, t: STRING_32)
			-- Initialize with the given link and text
		do
			make_control ("a")
			text := t
			attributes := "href=%"" + link + "%"";
			add_class ("list-group-item")
		ensure
			text_set: text = t
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
			-- Set whether this item should be displayed as active or not
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
		ensure
			active_set: active = a
			state_changes_registered: old active /= active implies state_changes.has_key ("active")
		end

feature -- Properties

	active: BOOLEAN
			-- The active state of this item

end
