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
			read_state,
			load_state
		end

create
	make

feature {NONE}

	controls: LINKED_LIST [WSF_CONTROL]

	make (n: STRING)
		do
			control_name := n
			controls := create {LINKED_LIST [WSF_CONTROL]}.make;
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	load_state (new_states: JSON_OBJECT)
		-- Pass new_states to subcontrols
		do
			Precursor(new_states)
			across
				controls as c
			loop
				c.item.load_state (new_states)
			end
		end

	set_state (new_state: JSON_OBJECT)
		do
		end

	read_state (states: JSON_OBJECT)
		-- Read states in subcontrols
		do
			Precursor(states)
			across
				controls as c
			loop
				c.item.read_state (states)
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
