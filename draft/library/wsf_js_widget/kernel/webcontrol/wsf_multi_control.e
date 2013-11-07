note
	description: "Summary description for {WSF_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MULTI_CONTROL [G -> WSF_STATELESS_CONTROL]

inherit

	WSF_CONTROL
		rename
			make as make_control
		redefine
			full_state,
			read_state_changes,
			load_state
		end

create
	make, make_with_tag_name

feature {NONE} -- Initialization

	make
			-- Initialize with specified control name and default tag "div"
		do
			make_with_tag_name ("div")
		end

	make_with_tag_name (t: STRING)
			-- Initialize with specified control name and tag
		do
			make_control (t)
			controls := create {ARRAYED_LIST [G]}.make (5);
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	load_state (new_states: JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			if attached {JSON_OBJECT} new_states.item ("controls") as ct then
				load_subcontrol_state (ct)
			end
		end

	load_subcontrol_state (newstate: JSON_OBJECT)
		do
			across
				controls as c
			loop
				if attached {WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]} c.item as cont then
					cont.load_subcontrol_state (newstate)
				elseif attached {WSF_CONTROL} c.item as cont then
					if attached {JSON_OBJECT} newstate.item (cont.control_name) as value_state then
						cont.load_state (value_state)
					end
				end
			end
		end

	set_state (new_state: JSON_OBJECT)
			-- Before we process the callback. We restore the state of control.
		do
		end

	full_state: WSF_JSON_OBJECT
			-- Read states in subcontrols
		local
			controls_state: WSF_JSON_OBJECT
		do
			Result := Precursor
			create controls_state.make
			read_subcontrol_state (controls_state)
			Result.put (controls_state, "controls")
		end

	read_subcontrol_state (controls_state: JSON_OBJECT)
		do
			across
				controls as c
			loop
				if attached {WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]} c.item as mcont then
					mcont.read_subcontrol_state (controls_state)
				elseif attached {WSF_CONTROL} c.item as cont then
					controls_state.put (cont.full_state, cont.control_name)
				end
			end
		end

	read_state_changes (states: WSF_JSON_OBJECT)
			-- Read states_changes in subcontrols
		local
			sub_states: WSF_JSON_OBJECT
			control_state: WSF_JSON_OBJECT
		do
			Precursor (states)
			create sub_states.make
			read_subcontrol_state_changes (sub_states)
			if sub_states.count>0 then
				if attached {JSON_OBJECT}states.item (control_name) as changes then
					changes.put (sub_states, "controls")
				else
					create control_state.make
					control_state.put (sub_states, "controls")
					states.put (control_state, control_name)
				end
			end
		end

	read_subcontrol_state_changes (states: WSF_JSON_OBJECT)
		do
			across
				controls as c
			loop
				if attached {WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]} c.item as cont then
					cont.read_subcontrol_state_changes (states)
				elseif attached {WSF_CONTROL} c.item as cont then
					cont.read_state_changes (states)
				end
			end
		end

	state: WSF_JSON_OBJECT
			--Read state
		do
			create Result.make
		end

feature -- Event handling

	handle_callback (cname: LIST [STRING]; event: STRING; event_parameter: detachable STRING)
			-- Pass callback to subcontrols
		do
			if equal (cname [1], control_name) then
				cname.go_i_th (1)
				cname.remove
				across
					controls as c
				loop
					if attached {WSF_CONTROL} c.item as cont then
						cont.handle_callback (cname, event, event_parameter)
					end
				end
			end
		end

feature -- Rendering

	render: STRING
			-- HTML representation of this multi control
		do
			Result := ""
			across
				controls as c
			loop
				Result := Result + c.item.render
			end
			if not tag_name.is_empty then
				Result := render_tag (Result, "")
			end
		end

feature

	add_control (c: G)
			-- Add a control to this multi control
		do
			controls.extend (c)
			if attached {WSF_CONTROL} c as d then
				d.control_id := controls.count
			end
		end

feature -- Properties

	stateless: BOOLEAN

	controls: ARRAYED_LIST [G]
			-- List of current controls in this multi control

end
