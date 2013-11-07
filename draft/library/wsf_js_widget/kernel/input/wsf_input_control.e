note
	description: "Summary description for {WSF_TEXT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_INPUT_CONTROL

inherit

	WSF_VALUE_CONTROL [STRING]
		rename
			make as make_value_control
		end

create
	make

feature {NONE} -- Initialization

	make (v: STRING)
			-- Initialize with specified name and value
		do
			make_value_control ( "input")
			type := "text"
			text := v
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		do
			if attached {JSON_STRING} new_state.item ("text") as new_text then
				text := new_text.unescaped_string_32
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put_string (text, "text")
			Result.put_boolean (attached change_event, "callback_change")
		end

feature --Event handling

	set_change_event (e: attached like change_event)
			-- Set text change event handle
		do
			change_event := e
		end

	handle_callback (cname: LIST[STRING]; event: STRING; event_parameter: detachable STRING)
		do 
			if Current.control_name.same_string (cname[1]) and attached change_event as cevent then
				if event.same_string ("change") then
					cevent.call (Void)
				end
			end
		end

feature -- Rendering

	render: STRING
		do
			Result := render_tag ("", "type=%"" + type + "%" value=%"" + text + "%"")
		end

feature -- Change

	set_text (t: STRING)
			-- Set text to be displayed
		do
			if not t.same_string (text) then
				text := t
				state_changes.replace (create {JSON_STRING}.make_json (text), "text")
			end
		end

feature -- Implementation

	value: STRING
		do
			Result := text
		end

feature -- Properties

	text: STRING
			-- Text to be displayed

	type: STRING
			-- Type of this input control

	change_event: detachable PROCEDURE [ANY, TUPLE]
			-- Procedure to be execued on change

end
