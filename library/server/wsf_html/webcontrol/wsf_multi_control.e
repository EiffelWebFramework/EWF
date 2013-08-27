note
	description: "Summary description for {WSF_MULTI_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_MULTI_CONTROL

inherit

	WSF_CONTROL

create
	make

feature {NONE}

	controls: LIST [WSF_CONTROL]

	make (n: STRING)
		do
			control_name := n
			controls := create {LINKED_LIST [WSF_CONTROL]}.make;
		end

	handle_callback (event: STRING; cname: STRING; page: WSF_PAGE_CONTROL)
		do
			if equal (cname, control_name) then

			else
				across
					controls as c
				loop
					c.item.handle_callback(event, cname, page)
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

end
