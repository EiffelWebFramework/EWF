note
	description: "Summary description for {DEMO_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEMO_DATA

inherit

	WSF_ENTITY

create
	make

feature {NONE}

	make (a_id: INTEGER; a_name, a_description: STRING)
		do
			id := a_id
			name := a_name
			description := a_description
		end

feature

	id: INTEGER

	name: STRING

	description: STRING

	get (field: STRING): detachable ANY
		do
			if field.is_equal ("id") then
				Result := id
			elseif field.is_equal ("name") then
				Result := name
			elseif field.is_equal ("description") then
				Result := description
			end
		end

end
