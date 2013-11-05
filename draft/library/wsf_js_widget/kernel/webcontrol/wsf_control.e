note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL

inherit

	WSF_STATELESS_CONTROL
		rename
			make as make_stateless_control
		redefine
			render_tag
		end

feature {NONE} -- Initialization

	make (n, a_tag_name: STRING)
			-- Initialize with specified control name and tag
		require
			not n.is_empty
			not a_tag_name.is_empty
		do
			make_stateless_control (a_tag_name)
			control_name := n
			create state_changes.make
			create actions.make_array
		ensure
			attached state_changes
		end

feature -- Actions

	start_modal (url: STRING; title: STRING)
			--Start a modal window containg an other or the same page
		local
			modal: WSF_JSON_OBJECT
		do
			create modal.make
			modal.put_string ("start_modal", "type")
			modal.put_string (url, "url")
			modal.put_string (title, "title")
			actions.add (modal)
		end

	start_modal_big (url: STRING; title: STRING)
			--Start a modal window containg an other or the same page
		local
			modal: WSF_JSON_OBJECT
		do
			create modal.make
			modal.put_string ("start_modal_big", "type")
			modal.put_string (url, "url")
			modal.put_string (title, "title")
			actions.add (modal)
		end

	show_alert (mesage: STRING)
			--Start a modal window containg an other or the same page
		local
			modal: WSF_JSON_OBJECT
		do
			create modal.make
			modal.put_string ("show_alert", "type")
			modal.put_string (mesage, "message")
			actions.add (modal)
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	load_state (new_states: JSON_OBJECT)
			-- Select state stored with `control_name` as key
		do
			if attached {JSON_OBJECT} new_states.item ("state") as new_state_obj then
				set_state (new_state_obj)
			end
		end

	set_state (new_state: JSON_OBJECT)
			-- Before we process the callback. We restore the state of control.
		deferred
		end

	full_state: WSF_JSON_OBJECT
			-- Return state of object
		do
			create Result.make
			Result.put (state, "state")
		end

	read_state_changes (states: WSF_JSON_OBJECT)
			-- Add a new entry in the `states_changes` JSON object with the `control_name` as key and the `state` as value
		do
			if state_changes.count > 0 then
				states.put (state_changes, control_name)
			end
			if actions.count > 0 then
				if not attached states.item ("actions") then
					states.put (create {JSON_ARRAY}.make_array, "actions")
				end
				if attached {JSON_ARRAY} states.item ("actions") as action_list then
					across
						actions.array_representation as action
					loop
						action_list.add (action.item)
					end
				end
			end
		end

	state: WSF_JSON_OBJECT
			-- Returns the current state of the Control as JSON. This state will be transfered to the client.
		deferred
		ensure
			controls_not_defined: not (attached Result.item ("controls"))
		end

	state_changes: WSF_JSON_OBJECT

feature -- Rendering

	render_tag (body: STRING; attrs: detachable STRING): STRING
			-- Render this control with the specified body and attributes
		do
			Result := render_tag_with_generator_name (generator, body, attrs)
		end

	render_tag_with_generator_name (a_generator, body: STRING; attrs: detachable STRING): STRING
			-- Render this control with the specified generator name, body and attributes
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
			l_attributes := "id=%"" + control_name + "%" data-name=%"" + control_name + "%" data-type=%"" + a_generator + "%" "
			if attached attrs as a then
				l_attributes := l_attributes + a
			end
			if isolate then
				l_attributes.append (" data-isolation=%"1%"")
			end
			Result := render_tag_with_tagname (tag_name, body, l_attributes, css_classes_string)
		end

feature -- Event handling

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
			-- Method called if any callback received. In this method you can route the callback to the event handler
		deferred
		end

feature -- Change

	set_isolation (p: BOOLEAN)
		do
			isolate := p
		end

feature -- Properties

	isolate: BOOLEAN

	actions: JSON_ARRAY

	control_name: STRING

end
