note
	description: "Summary description for {WSF_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MULTI_CONTROL

inherit

	WSF_CONTROL
		redefine
			make,
			read_state,
			read_state_changes,
			load_state
		end

create
	make

feature {NONE}

	controls: LINKED_LIST [WSF_CONTROL]

	make (n: STRING)
		do
			Precursor (n)
			controls := create {LINKED_LIST [WSF_CONTROL]}.make;
		end

	make_with_controls (n: STRING; c: LINKED_LIST [WSF_CONTROL])
		do
			control_name := n
			controls := c
			create state_changes.make
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

	handle_callback (event: STRING; cname: STRING)
			-- Pass callback to subcontrols
		do
			if equal (cname, control_name) then
			else
				across
					controls as c
				loop
					c.item.handle_callback (event, cname)
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
		end

	add_control (c: WSF_CONTROL)
		do
			controls.put_front (c)
		end

end
