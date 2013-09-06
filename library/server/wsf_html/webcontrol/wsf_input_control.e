note
	description: "Summary description for {WSF_TEXT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_INPUT_CONTROL

inherit

	WSF_VALUE_CONTROL [STRING]

create
	make_input

feature {NONE}

	make_input (n: STRING; v: STRING)
		do
			make (n, "input")
			type := "text"
			text := v
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		do
			if attached {JSON_STRING} new_state.item (create {JSON_STRING}.make_json ("text")) as new_text then
				text := new_text.unescaped_string_32
			end
		end

	state: JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (text), create {JSON_STRING}.make_json ("text"))
			Result.put (create {JSON_BOOLEAN}.make_boolean (attached change_event), create {JSON_STRING}.make_json ("callback_change"))
		end

feature --EVENT HANDLING

	set_change_event (e: attached like change_event)
			-- Set text change event handle
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

feature -- Implementation

	render: STRING
		do
			Result := render_tag ("", "type=%"" + type + "%" value=%"" + text + "%"")
		end

	set_text (t: STRING)
		do
			if not t.is_equal (text) then
				text := t
				state_changes.replace (create {JSON_STRING}.make_json (text), create {JSON_STRING}.make_json ("text"))
			end
		end

	value: STRING
		do
			Result := text
		end

feature

	text: STRING

	type: STRING

	change_event: detachable PROCEDURE [ANY, TUPLE []]

end
