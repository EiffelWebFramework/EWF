note
	description: "[
		Represents a button control (button html keyword). Provides a
		callback agent which will be invoked when the button is clicked.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BUTTON_CONTROL

inherit

	WSF_CONTROL
		rename
			make as make_control
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: STRING_32)
			-- Initialize with specified text
		do
			make_control ("button")
			add_class ("btn")
			add_class ("btn-default")
			text := a_text
		ensure
			text_set: text = a_text
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
			Result.put_boolean (disabled, "disabled")
			Result.put_boolean (attached click_event, "callback_click")
		end

feature --Event handling

	set_click_event (e: attached like click_event)
			-- Set button click event handle
		do
			click_event := e
		ensure
			click_event_set: click_event = e
		end

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- Called if the button is clicked.
		do
			if
				control_name.same_string_general (cname.first) and
				attached click_event as cevent
			then
				cevent.call (Void)
			end
		end

feature -- Rendering

	render: STRING_32
			-- HTML representation of this control
		local
			attr: STRING_32
		do
			create attr.make_empty
			if attached attributes as a then
				attr.append (a)
			end
			if disabled then
				attr.append (" disabled=%"disabled%" ")
			end
			Result := render_tag (text, attr)
		end

feature -- Change

	set_text (t: STRING_32)
			-- Set text of that button
		do
			if not t.same_string (text) then
				text := t
				state_changes.replace_with_string (text, "text")
			end
		ensure
			text_set: text.same_string (t)
		end

	set_disabled (b: BOOLEAN)
			-- Enables or disables this component, depending on the value of the parameter b.
			-- A disabled button cannot be clicked.
		do
			if disabled /= b then
				disabled := b
				state_changes.replace_with_boolean (disabled, "disabled")
			else
				check (b = False) implies state_changes.has_key ("disabled") end
			end
		ensure
			disabled_set: disabled = b
		end

feature -- Properties

	disabled: BOOLEAN
			-- Defines if the button is clickable or not

	text: STRING_32
			-- The text currently displayed on this button

	click_event: detachable PROCEDURE [ANY, TUPLE]
			-- Event that is executed when button is clicked

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
