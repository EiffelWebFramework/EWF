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
			create pending_removes.make (1)
		end

feature {WSF_DYNAMIC_MULTI_CONTROL} -- Iternal functions

	add_control (c: G; id: INTEGER_32)
			-- Add a control to this multi control
		do
			controls.extend (c)
			if attached {WSF_CONTROL} c as d then
				d.control_id := id
			end
			max_id := id.max (max_id)
			items_changed := True
		end

	execute_pending_removes
		local
			found: BOOLEAN
			fitem: detachable G
			frow: detachable JSON_OBJECT
		do
			across
				pending_removes as id
			loop
				across
					controls as c
				until
					found
				loop
					if c.item.control_id = id.item then
						fitem := c.item
						found := True
					end
				end
				if attached fitem as i then
					controls.prune (i)
				end
				found := False
				across
					items.array_representation as c
				until
					found
				loop
					if attached {JSON_OBJECT} c.item as row and then attached {JSON_NUMBER} row.item ("id") as rid and then rid.item.to_integer_32 = id.item then
						frow := row
						found := True
					end
				end
				if attached frow as r then
					items.array_representation.prune (r)
				end
				items_changed := True
			end
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

	remove_control_by_id (id: INTEGER)
			--Add removes to pending removes list
		do
			pending_removes.extend (id)
		end

	read_state_changes (states: WSF_JSON_OBJECT)
		local
			new_state: WSF_JSON_OBJECT
			sub_state: WSF_JSON_OBJECT
		do
			Precursor (states)
			execute_pending_removes
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

	pending_removes: ARRAYED_LIST [INTEGER]

	items_changed: BOOLEAN

	max_id: INTEGER

invariant
	all_items_exist: items.count = controls.count

end
