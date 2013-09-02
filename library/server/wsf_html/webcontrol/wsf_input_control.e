note
	description: "Summary description for {WSF_INPUT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_INPUT_CONTROL

inherit

	WSF_CONTROL

create
	make_input

feature {NONE}

	make_input (n, t, v: STRING)
		do
		    make (n)
			type := t
			value := v
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	set_state (new_state: JSON_OBJECT)
			-- Restore value from json
		do
			if attached {JSON_STRING} new_state.item (create {JSON_STRING}.make_json ("value")) as new_value then
				value := new_value.unescaped_string_32
			end
		end

	state: JSON_OBJECT
			-- Return state which contains the current value and if there is an event handle attached
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (value), create {JSON_STRING}.make_json ("value"))
			Result.put (create {JSON_BOOLEAN}.make_boolean (attached change_event), create {JSON_STRING}.make_json ("callback_change"))
		end

feature --EVENT HANDLING

	set_change_event (e: attached like change_event)
			-- Set input change event handle
		do
			change_event := e
		end

	handle_callback (cname: STRING; event: STRING)
		do
			if Current.control_name.is_equal (cname) and attached change_event as cevent then
				if event.is_equal ("change") then
					cevent.call ([])
				end
			end
		end

feature

	render: STRING
		do
			Result := "<input type=%"" + type + "%" data-name=%"" + control_name + "%" data-type=%"WSF_TEXT_CONTROL%" value=%"" + value + "%" />"
		end

	set_value (v: STRING)
		do
			if not v.is_equal (value) then
				value := v
				state_changes.replace (create {JSON_STRING}.make_json (value), create {JSON_STRING}.make_json ("value"))
			end
		end

feature

	type: STRING

	value: STRING

	change_event: detachable PROCEDURE [ANY, TUPLE []]

end
