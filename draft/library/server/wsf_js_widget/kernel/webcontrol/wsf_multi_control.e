note
	description: "[
		Mutli controls are used as containers for multiple controls, for
		example a form is a multi control.
	]"
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
			-- Initialize with default tag "div"
		do
			make_with_tag_name ("div")
		end

	make_with_tag_name (a_tag: STRING_32)
			-- Initialize with specified tag `a_tag'.
		require
			a_tag_not_empty: not a_tag.is_empty
		do
			make_control (a_tag)
			create {ARRAYED_LIST [G]} controls.make (5)
		ensure
			tag_name_set: tag_name.same_string (a_tag)
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
			-- load the new state in to the subcontrols
			-- If the subcontrol is a stateless multicontrol x. We load the controls_state in to the subcontrols of x directly. (Stateless multi controls do not add a hierarchy level)
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
			l_state: WSF_JSON_OBJECT
		do
			Result := Precursor
			create l_state.make
			add_sub_controls_states_to (l_state)
			Result.put (l_state, "controls")
		end

	add_sub_controls_states_to (a_controls_state: JSON_OBJECT)
			-- Read add subcontrol state in to the `a_controls_state' json object.
			-- If the subcontrol is a stateless multicontrol x,
			--   the states of the subcontrols of x are directly added to `a_controls_state'.
			-- (Stateless multi controls do not add a hierarchy level)
		do
			across
				controls as c
			loop
				if attached {WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]} c.item as mcont then
					mcont.add_sub_controls_states_to (a_controls_state)
				elseif attached {WSF_CONTROL} c.item as cont then
					a_controls_state.put (cont.full_state, cont.control_name)
				end
			end
		end

	read_state_changes (states: WSF_JSON_OBJECT)
			-- Read states_changes in subcontrols and add them to the states json object under  `control name > "controls"
		local
			sub_states: WSF_JSON_OBJECT
			control_state: WSF_JSON_OBJECT
		do
			Precursor (states)
			create sub_states.make
			read_subcontrol_state_changes (sub_states)
			if sub_states.count > 0 then
				if attached {JSON_OBJECT} states.item (control_name) as changes then
					changes.put (sub_states, "controls")
				else
					create control_state.make
					control_state.put (sub_states, "controls")
					states.put (control_state, control_name)
				end
			end
		end

	read_subcontrol_state_changes (sub_states: WSF_JSON_OBJECT)
			-- Read add subcontrol changes in to the sub_states json object.
			-- If the subcontrol is a stateless multicontrol x. We add the state changes of subcontrols of x directly to sub_states. (Stateless multi controls do not add a hierarchy level)
		do
			across
				controls as ic
			loop
				if attached {WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]} ic.item as cont then
					cont.read_subcontrol_state_changes (sub_states)
				elseif attached {WSF_CONTROL} ic.item as cont then
					cont.read_state_changes (sub_states)
				end
			end
		end

	state: WSF_JSON_OBJECT
			--Read state
		do
			create Result.make
		end

feature -- Event handling

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- Pass callback to subcontrols
		do
			if cname.first.same_string (control_name) then
				cname.start
				cname.remove
				if not cname.is_empty then
					across
						controls as ic
					until
						cname.is_empty
					loop
						if attached {WSF_CONTROL} ic.item as cont then
							cont.handle_callback (cname, event, event_parameter)
						end
					end
				end
			end
		end

feature -- Rendering

	render: STRING_32
			-- HTML representation of this multi control
		do
			Result := ""
			across
				controls as c
			loop
				Result := Result + c.item.render
			end
			if not tag_name.is_empty then
				Result := render_tag (Result, attributes)
			end
		end

feature

	add_control (a_control: G)
			-- Add a control `a_control' to this multi control.
		do
			controls.extend (a_control)
			if attached {WSF_CONTROL} a_control as d then
				d.control_id := controls.count
			end
		end

feature -- Properties

	controls: ARRAYED_LIST [G]
			-- List of current controls in this multi control

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
