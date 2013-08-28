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
	make

feature {NONE}

	make (n: STRING; v: STRING)
		do
			control_name := n
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
			Result.put (create {JSON_BOOLEAN}.make_boolean (attached click_event), create {JSON_STRING}.make_json ("callback_click"))
		end

feature --EVENT HANDLING

	set_click_event (e: attached like click_event)
		-- Set button click event handle
		do
			click_event := e
		end

	handle_callback (cname: STRING; event: STRING)
		do
			if Current.control_name.is_equal (cname) and attached click_event as cevent then
				cevent.call ([])
			end
		end

feature

	render: STRING
		do
			Result := "<button data-name=%"" + control_name + "%" data-type=%"WSF_BUTTON_CONTROL%">" + text + "</button>"
		end

	set_text (t: STRING)
		do
			text := t
		end

feature

	text: STRING

	click_event: detachable PROCEDURE [ANY, TUPLE []]

end
