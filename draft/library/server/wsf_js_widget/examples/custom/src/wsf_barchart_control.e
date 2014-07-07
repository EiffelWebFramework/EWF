note
	description: "Summary description for {WSF_BARCHART_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BARCHART_CONTROL

inherit

	WSF_CONTROL
		rename
			make as make_control
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_control ("div")
			data := <<>>
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
			-- Restore data from json
		do
			if attached {JSON_ARRAY} new_state.item ("data") as new_data then
				create data.make_filled (["",0.0], 1, new_data.array_representation.count)
				across
					new_data.array_representation as d
				loop
					if attached {JSON_OBJECT} d.item as citem
						and then attached {JSON_STRING} citem.item ("key") as key
						and then attached {JSON_NUMBER} citem.item ("value") as value then
						data.put ([key.item,value.item.to_real_64], d.cursor_index)
					end
				end
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state with data
		do
			create Result.make
			Result.put (data_as_json, "data")
		end


feature -- Callback

	handle_callback (cname: LIST [STRING_32]; event: STRING_32; event_parameter: detachable ANY)
		do
				-- Do nothing here
		end

feature -- Data

	set_data (a_data: like data)
		do
			data := a_data
			state_changes.replace (data_as_json, "data")
		end

	data_as_json : JSON_ARRAY
	local
		item: WSF_JSON_OBJECT
	do
		create Result.make_array
		across
			data as el
		loop
			create item.make
			if attached {STRING_8} el.item.at(1) as key and attached {DOUBLE}el.item.at(2) as value then
			item.put_string (key, "key")
			item.put_real (value, "value")
			Result.add(item)
			end
		end
	end
	data: ARRAY [TUPLE [STRING_8, DOUBLE]]

feature -- Rendering

	render: STRING_32
		do
			Result := render_tag ("Loading ...", "")
		end

end
