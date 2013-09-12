note
	description: "Summary description for {WSF_CHECKBOX_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_CHECKBOX_CONTROL

inherit

	WSF_VALUE_CONTROL [BOOLEAN]

create
	make_checkbox

feature {NONE}

	make_checkbox (n: STRING; l: STRING; c: STRING)
		do
			make (n, "input")
			label := l
			checked_value := c
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		do
			if attached {JSON_BOOLEAN} new_state.item (create {JSON_STRING}.make_json ("checked")) as new_checked then
				checked := new_checked.item
			end
		end

	state: JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put (create {JSON_BOOLEAN}.make_boolean (checked), create {JSON_STRING}.make_json ("checked"))
			Result.put (create {JSON_STRING}.make_json (checked_value), create {JSON_STRING}.make_json ("checked_value"))
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
		local
			attributes: STRING
		do
			attributes := "type=%"checkbox%""
			if checked then
				attributes := attributes + " checked"
			end
			Result := render_tag_with_tagname ("div", render_tag_with_tagname ("label", render_tag ("", attributes) + " " + label, "", ""), "", "checkbox")
		end

	value: BOOLEAN
		do
			Result := checked
		end

feature

	label: STRING

	checked: BOOLEAN

	checked_value: STRING

	change_event: detachable PROCEDURE [ANY, TUPLE []]

end
