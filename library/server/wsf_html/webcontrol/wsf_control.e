note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL

feature

	control_name: STRING

	tag_name: STRING

	css_class: LINKED_LIST [STRING]

feature {NONE}

	make (n, a_tag_name: STRING)
		do
			control_name := n
			tag_name := a_tag_name
			create css_class.make
			create state_changes.make
		ensure
			attached state_changes
			attached css_class
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

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
			-- Method called if any callback recived. In this method you can route the callback to the event handler
		deferred
		end

feature

	render_tag(body,attributes:STRING):STRING
		local
			css_class_string: STRING
		do
			css_class_string := ""
			across
				css_class as c
			loop
				css_class_string := css_class_string + " " + c.item
			end
			if not css_class_string.is_empty then
				css_class_string := " class=%"" + css_class_string + "%""
			end
			Result:="<"+tag_name+"  data-name=%"" + control_name + "%" data-type=%""+generator+"%" "+attributes+css_class_string
			if not body.is_empty then
				Result := Result + " />"
			else
				Result := Result + " >" + body + "</" + tag_name + ">"
			end
		end

	render: STRING
			-- Return html representaion of control
		deferred
		end

end
