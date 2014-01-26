note
	description: "Summary description for {WSF_DYNAMIC_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_DYNAMIC_MULTI_CONTROL [G -> WSF_CONTROL]

inherit

	WSF_MULTI_CONTROL [G]
		rename
			add_control as add_control_internal
		redefine
			make_with_tag_name,
			set_state,
			state,
			read_state_changes,
			js_class
		end

feature {NONE} -- Initialization

	make_with_tag_name (tag: STRING)
		do
			Precursor (tag)
			create items.make_array
		end

feature {WSF_DYNAMIC_MULTI_CONTROL} -- Iternal functions

	add_control (c: G; id: INTEGER_32)
			-- Add a control to this multi control
		do
			controls.extend (c)
			if attached {WSF_CONTROL} c as d then
				d.control_id := id
				max_id := id.max (max_id)
			end
			items_changed := True
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Before we process the callback. We restore the subcontrols
		do
			if attached {JSON_ARRAY} new_state.item ("items") as new_items then
				items := new_items
				create controls.make (items.count)
				across
					new_items.array_representation as n
				loop
					if attached {JSON_OBJECT} n.item as record and then attached {JSON_NUMBER} record.item ("id") as id and then attached {JSON_STRING} record.item ("tag") as tag then
						if attached create_control_from_tag (tag.item) as control then
							add_control (control, id.item.to_integer_32)
						end
					end
				end
				items_changed := False
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		local
		do
			create Result.make
			Result.put (items, "items")
		end

feature

	create_control_from_tag (tag: STRING): detachable G
		deferred
		end

	add_control_from_tag (tag: STRING)
		local
			item: WSF_JSON_OBJECT
		do
			if attached create_control_from_tag (tag) as control then
				add_control (control, max_id + 1)
				create item.make
				item.put_integer (max_id, "id")
				item.put_string (tag, "tag")
				items.add (item)
			end
		end

	read_state_changes (states: WSF_JSON_OBJECT)
		local
			new_state: WSF_JSON_OBJECT
			sub_state: WSF_JSON_OBJECT
		do
			Precursor (states)
			if items_changed then
				new_state := state
				create sub_state.make
				read_subcontrol_state (sub_state)
				new_state.put (sub_state, "newstate")
				new_state.put_string (render, "render")
				states.put (new_state, control_name)
			end
		end

	js_class: STRING
		do
			Result := "WSF_DYNAMIC_MULTI_CONTROL"
		end

feature

	items: JSON_ARRAY

	items_changed: BOOLEAN

	max_id: INTEGER

end
