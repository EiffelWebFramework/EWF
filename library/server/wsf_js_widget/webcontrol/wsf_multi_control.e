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
			read_state,
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
			controls := create {ARRAYED_LIST [G]}.make(5);
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	load_state (new_states: JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			across
				controls as c
			loop
				if attached {WSF_CONTROL} c.item as cont then
					cont.load_state (new_states)
				end
			end
		end

	set_state (new_state: JSON_OBJECT)
			-- Before we process the callback. We restore the state of control.
		do
		end

	read_state (states: JSON_OBJECT)
			-- Read states in subcontrols
		do
			Precursor (states)
			across
				controls as c
			loop
				if attached {WSF_CONTROL} c.item as cont then
					cont.read_state (states)
				end
			end
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
				Result := c.item.render + Result
			end
			Result := render_tag (Result, "")
		end

feature -- Change

	add_control (c: detachable G)
			-- Add a control to this multi control
		do
			if attached c as d then
				controls.put_front (d)
			end
		end

feature -- Properties

	controls: ARRAYED_LIST [G]
			-- List of current controls in this multi control

end
