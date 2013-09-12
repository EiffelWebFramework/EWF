note
	description: "Summary description for {WSF_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MULTI_CONTROL [G -> WSF_CONTROL]

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
		do
			make_with_tag_name(n, "div")
		end

	make_with_tag_name (n, t: STRING)
		do
			make_control (n, t)
			controls := create {LINKED_LIST [G]}.make;
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	load_state (new_states: JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			across
				controls as c
			loop
				c.item.load_state (new_states)
			end
		end

	set_state (new_state: JSON_OBJECT)
		do
			across
				controls as c
			loop
				c.item.set_state (new_state)
			end
		end

	read_state (states: JSON_OBJECT)
			-- Read states in subcontrols
		do
			Precursor (states)
			across
				controls as c
			loop
				c.item.read_state (states)
			end
		end

	read_state_changes (states: JSON_OBJECT)
			-- Read states_changes in subcontrols
		do
			Precursor (states)
			across
				controls as c
			loop
				c.item.read_state_changes (states)
			end
		end

	state: JSON_OBJECT
			--Read state
		do
			create Result.make
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
			-- Pass callback to subcontrols
		do
			if equal (cname, control_name) then
			else
				across
					controls as c
				loop
					c.item.handle_callback (cname, event)
				end
			end
		end

feature

	render: STRING
		do
			Result := ""
			across
				controls as c
			loop
				Result := c.item.render + Result
			end
			Result := render_tag (Result, "")
		end

	add_control (c: G)
		do
			controls.put_front (c)
		end

	controls: LINKED_LIST [G]

end
