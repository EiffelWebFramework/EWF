note
	description: "Summary description for {WSF_STATELESS_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STATELESS_MULTI_CONTROL

inherit

	WSF_STATELESS_CONTROL

create
	make_multi_control, make_with_tag_name

feature {NONE} -- Initialization

	make_multi_control
			-- Initialize with default tag "div"
		do
			make_with_tag_name ("div")
		end

	make_with_tag_name (t: STRING)
			-- Initialize with specified tag
		do
			make (t)
			controls := create {LINKED_LIST [WSF_STATELESS_CONTROL]}.make;
		end

feature -- Rendering

	render: STRING
			-- HTML representation of this stateless multi control
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

	add_control (c: WSF_STATELESS_CONTROL)
			-- Add control to this stateless multi control
		do
			controls.put_front (c)
		end

feature -- Properties

	controls: LINKED_LIST [WSF_STATELESS_CONTROL]
			-- List of controls

end
