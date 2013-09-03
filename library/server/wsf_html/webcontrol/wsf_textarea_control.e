note
	description: "Summary description for {WSF_TEXT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_TEXTAREA_CONTROL

inherit

	WSF_CONTROL

create
	make_textarea

feature {NONE}

	make_textarea (n, t: STRING)
		do
			make (n)
			text := t
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

feature

	render: STRING
		do
			Result := "<textarea data-name=%"" + control_name + "%" data-type=%"WSF_TEXTAREA_CONTROL%">" + text + "</textarea>"
		end

	set_text (t: STRING)
		do
			if not t.is_equal (text) then
				text := t
				state_changes.replace (create {JSON_STRING}.make_json (text), create {JSON_STRING}.make_json ("text"))
			end
		end

feature

	text: STRING

	change_event: detachable PROCEDURE [ANY, TUPLE []]

end
