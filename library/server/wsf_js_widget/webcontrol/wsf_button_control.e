note
	description: "Summary description for {WSF_BUTTON_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BUTTON_CONTROL

inherit

	WSF_CONTROL

create
	make_button

feature {NONE}

	make_button (n: STRING; t: STRING)
		do
			make_control (n, "button")
			add_class ("btn")
			add_class ("btn-default")
			text := t
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		do
			if attached {JSON_STRING} new_state.item ("text") as new_text then
				text := new_text.unescaped_string_32
			end
		end

	state: JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (text), "text")
			Result.put (create {JSON_BOOLEAN}.make_boolean (attached click_event), "callback_click")
		end

feature --EVENT HANDLING

	set_click_event (e: attached like click_event)
			-- Set button click event handle
		do
			click_event := e
		end

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
		do
			if Current.control_name.same_string (cname) and attached click_event as cevent then
				cevent.call (Void)
			end
		end

feature

	render: STRING
		do
			Result := render_tag (text, "")
		end

	set_text (t: STRING)
		do
			if not t.same_string (text) then
				text := t
				state_changes.replace (create {JSON_STRING}.make_json (text), "text")
			end
		end

feature

	text: STRING

	click_event: detachable PROCEDURE [ANY, TUPLE]

end
