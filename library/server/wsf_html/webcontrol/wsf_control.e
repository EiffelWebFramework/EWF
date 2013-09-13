	note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL

inherit

	WSF_STATELESS_CONTROL
		redefine
			render_tag
		end

feature

	control_name: STRING

feature {NONE}

	make_control (n, a_tag_name: STRING)
		do
			make (a_tag_name)
			control_name := n
			create state_changes.make
		ensure
			attached state_changes
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	load_state (new_states: JSON_OBJECT)
			-- Select state stored with `control_name` as key
		do
			if attached {JSON_OBJECT} new_states.item (create {JSON_STRING}.make_json (control_name)) as new_state_obj then
				set_state (new_state_obj)
			end
		end

	set_state (new_state: JSON_OBJECT)
			-- Before we process the callback. We restore the state of control.
		deferred
		end

	read_state (states: JSON_OBJECT)
			-- Add a new entry in the `states` JSON object with the `control_name` as key and the `state` as value
		do
			states.put (state, create {JSON_STRING}.make_json (control_name))
		end

	read_state_changes (states: JSON_OBJECT)
			-- Add a new entry in the `states_changes` JSON object with the `control_name` as key and the `state` as value
		do
			if state_changes.count > 0 then
				states.put (state_changes, create {JSON_STRING}.make_json (control_name))
			end
		end

	state: JSON_OBJECT
			-- Returns the current state of the Control as JSON. This state will be transfered to the client.
		deferred
		end

	state_changes: JSON_OBJECT

feature -- Rendering

	render_tag (body, attrs: STRING): STRING
		local
			css_classes_string: STRING
			l_attributes: STRING
		do
			css_classes_string := ""
			across
				css_classes as c
			loop
				css_classes_string := css_classes_string + " " + c.item
			end
			l_attributes := "id=%"" + control_name + "%" data-name=%"" + control_name + "%" data-type=%"" + generator + "%" " + attrs
			Result := render_tag_with_tagname (tag_name, body, l_attributes, css_classes_string)
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
			-- Method called if any callback received. In this method you can route the callback to the event handler
		deferred
		end

end
