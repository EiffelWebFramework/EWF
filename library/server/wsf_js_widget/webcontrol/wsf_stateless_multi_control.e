note
	description: "Summary description for {WSF_STATELESS_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STATELESS_MULTI_CONTROL [G -> WSF_STATELESS_CONTROL]

inherit

	WSF_STATELESS_CONTROL

create
	make_multi_control, make_with_tag_name

feature {NONE} -- Initialization

	make_multi_control
		do
			make_with_tag_name ("div")
		end

	make_with_tag_name (t: STRING)
		do
			make (t)
			controls := create {LINKED_LIST [G]}.make;
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
