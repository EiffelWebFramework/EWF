note
	description: "Summary description for {WSF_CHECKBOX_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_CHECKBOX_CONTROL

inherit

	WSF_VALUE_CONTROL [BOOLEAN]
		rename
			make as make_value_control
		end

create
	make

feature {NONE} -- Initialization

	make (l, c: STRING)
			-- Initialize with specified control name,
		do
			make_value_control ("input")
			label := l
			checked_value := c
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		do
			if attached {JSON_BOOLEAN} new_state.item ("checked") as new_checked then
				checked := new_checked.item
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put_boolean (checked, "checked")
			Result.put_string (checked_value, "checked_value")
			Result.put_boolean (attached change_event, "callback_change")
		end

feature --Event handling

	set_change_event (e: attached like change_event)
			-- Set text change event handle
		do
			change_event := e
		end

	handle_callback (cname: LIST [STRING]; event: STRING; event_parameter: detachable ANY)
		do
			if Current.control_name.same_string (cname [1]) and attached change_event as cevent then
				if event.same_string ("change") then
					cevent.call (Void)
				end
			end
		end

feature -- Implementation

	render: STRING
		local
			attrs: STRING
		do
			attrs := "type=%"checkbox%""
			if checked then
				attrs := attrs + " checked"
			end
			Result := render_tag_with_tagname ("div", render_tag_with_tagname ("label", render_tag ("", attrs) + " " + label, "", ""), "", "checkbox")
		end

	value: BOOLEAN
		do
			Result := checked
		end

	set_value (v: BOOLEAN)
		do
			checked := v
		end

feature -- Properties

	label: STRING
			-- The label of the checkbox control

	checked: BOOLEAN
			-- The checked value of the checkbox control

	checked_value: STRING
			-- String checked value

	change_event: detachable PROCEDURE [ANY, TUPLE]
			-- Function to be executed on change

end
