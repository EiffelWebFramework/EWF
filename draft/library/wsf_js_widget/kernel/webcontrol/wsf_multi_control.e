note
	description: "Summary description for {WSF_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MULTI_CONTROL [G -> WSF_STATELESS_CONTROL]

inherit

	WSF_CONTROL
		redefine
			full_state,
			read_state_changes,
			load_state
		end

create
	make_multi_control, make_with_tag_name

feature {NONE} -- Initialization

	make_multi_control (n: STRING)
			-- Initialize with specified control name and default tag "div"
		do
			make_with_tag_name (n, "div")
		end

	make_with_tag_name (n, t: STRING)
			-- Initialize with specified control name and tag
		do
			make_control (n, t)
			controls := create {ARRAYED_LIST [G]}.make (5);
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	load_state (new_states: JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			if attached {JSON_OBJECT} new_states.item ("controls") as ct then
				across
					controls as c
				loop
					if attached {WSF_CONTROL} c.item as cont then
						if attached {JSON_OBJECT} ct.item (cont.control_name) as value_state then
							cont.load_state (value_state)
						end
					end
				end
			end
		end

	set_state (new_state: JSON_OBJECT)
			-- Before we process the callback. We restore the state of control.
		do
		end

	full_state: JSON_OBJECT
			-- Read states in subcontrols
		local
			controls_state: JSON_OBJECT
		do
			Result := Precursor
			create controls_state.make
			across
				controls as c
			loop
				if attached {WSF_CONTROL} c.item as cont then
					controls_state.put (cont.full_state, cont.control_name)
				end
			end
			Result.put (controls_state, "controls")
		end

	read_state_changes (states: JSON_OBJECT)
			-- Read states_changes in subcontrols
		do
			Precursor (states)
			across
				controls as c
			loop
				if attached {WSF_CONTROL} c.item as cont then
					cont.read_state_changes (states)
				end
			end
		end

	state: JSON_OBJECT
			--Read state
		do
			create Result.make
		end

feature -- Event handling

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
			-- Pass callback to subcontrols
		do
			if equal (cname, control_name) then
			else
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
			Result := render_tag (Result, "")
		end

feature -- Change

	add_control (c: G)
			-- Add a control to this multi control
		do
				controls.extend (c)
		end

feature -- Properties

	controls: ARRAYED_LIST [G]
			-- List of current controls in this multi control

end
