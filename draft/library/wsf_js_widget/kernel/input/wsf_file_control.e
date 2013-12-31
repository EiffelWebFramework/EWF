note
	description: "Summary description for {WSF_FILE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE_CONTROL

inherit

	WSF_VALUE_CONTROL [detachable WSF_PENDING_FILE]
		rename
			make as make_value_control
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_value_control ("input")
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		do
			if attached {JSON_STRING} new_state.item ("file") as new_name and attached {JSON_STRING} new_state.item ("type") as new_type and attached {JSON_NUMBER} new_state.item ("size") as new_size then
				create file.make (new_name.unescaped_string_32, new_type.unescaped_string_32, new_size.item.to_integer_32);
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put_boolean (attached change_event, "callback_change")
		end

feature --Event handling

	set_change_event (e: attached like change_event)
			-- Set text change event handle
		do
			change_event := e
		end

	handle_callback (cname: LIST [STRING]; event: STRING; event_parameter: detachable STRING)
		do
			if Current.control_name.same_string (cname [1]) and attached change_event as cevent then
				if event.same_string ("change") then
					cevent.call (Void)
				end
			end
		end

feature -- Implementation

	value: detachable WSF_PENDING_FILE
		do
			Result := file
		end

	render: STRING
		do
			Result := render_tag ("", "type=%"file%"  ")
		end

feature -- Properties

	file: detachable WSF_PENDING_FILE
			-- Text to be displayed

	change_event: detachable PROCEDURE [ANY, TUPLE]
			-- Procedure to be execued on change

end
