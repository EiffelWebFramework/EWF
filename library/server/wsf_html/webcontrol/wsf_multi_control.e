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
			read_state
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

feature

	add_control (c: WSF_CONTROL)
		do
			controls.put_front (c)
		end

	handle_callback (event: STRING; cname: STRING; page: WSF_PAGE_CONTROL)
		do
			if equal (cname, control_name) then
			else
				across
					controls as c
				loop
					c.item.handle_callback (event, cname, page)
				end
			end
		end

	render: STRING
		do
			Result := ""
			across
				controls as c
			loop
				Result := Result + c.item.render
			end
		end

	state: JSON_OBJECT
		local
			temp: JSON_OBJECT
		do
			create Result.make
			across
				controls as c
			loop
				temp := c.item.state
			end
		end

	read_state (states: JSON_OBJECT)
		do
			states.put (state, create {JSON_STRING}.make_json (control_name))
			across
				controls as c
			loop
				c.item.read_state(states)
			end
		end
end
