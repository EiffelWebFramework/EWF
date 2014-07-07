note
	description: "[
		This class is the base class for all stateful controls, like
		buttons or forms.
	]"
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

	make (a_tag_name: STRING_32)
			-- Initialize with specified tag
		require
			a_tag_name_not_empty: not a_tag_name.is_empty
		do
			make_stateless_control (a_tag_name)
			create control_name_prefix.make_empty
			create state_changes.make
			create actions.make_array
		ensure
			state_changes_attached: attached state_changes
		end

feature -- Actions

	start_modal (url: STRING_32; title: STRING_32; big: BOOLEAN)
			--Start a modal window containing an other or the same page
		require
			url_not_empty: not url.is_empty
			title_not_empty: not title.is_empty
		local
			modal: WSF_JSON_OBJECT
		do
			create modal.make
			if big then
				modal.put_string ("start_modal_big", "type")
			else
				modal.put_string ("start_modal", "type")
			end
			modal.put_string (url, "url")
			modal.put_string (title, "title")
			actions.add (modal)
		end

	show_alert (message: STRING_32)
			--Start a modal window containg an other or the same page
		require
			message_not_empty: not message.is_empty
		local
			alert: WSF_JSON_OBJECT
		do
			create alert.make
			alert.put_string ("show_alert", "type")
			alert.put_string (message, "message")
			actions.add (alert)
		end

	redirect (url: STRING_32)
			--Redirect to an other page
		require
			url_not_empty: not url.is_empty
		local
			modal: WSF_JSON_OBJECT
		do
			create modal.make
			modal.put_string ("redirect", "type")
			modal.put_string (url, "url")
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
				if states.item ("actions") = Void then
					states.put (create {JSON_ARRAY}.make_array, "actions")
				end
				if attached {JSON_ARRAY} states.item ("actions") as action_list then
					across
						actions.array_representation as ic
					loop
						action_list.add (ic.item)
					end
				end
			end
		end

	state: WSF_JSON_OBJECT
			-- Returns the current state of the Control as JSON. This state will be transfered to the client.
		deferred
		ensure
			controls_not_defined: Result.item ("controls") = Void
		end

	state_changes: WSF_JSON_OBJECT

feature -- Rendering

	render_tag (body: READABLE_STRING_32; attrs: detachable READABLE_STRING_32): STRING_32
			-- Render this control with the specified body and attributes
		do
			Result := render_tag_with_generator_name (js_class, body, attrs)
		end

	render_tag_with_generator_name (a_generator, body: READABLE_STRING_32; attrs: detachable READABLE_STRING_32): STRING_32
			-- Render this control with the specified generator name, body and attributes
		local
			l_css_classes_string: STRING_32
			l_attributes: STRING_32
		do
			create l_css_classes_string.make_empty
			across
				css_classes as ic
			loop
				l_css_classes_string.append_character (' ')
				l_css_classes_string.append (ic.item)
			end
			l_attributes := " data-name=%"" + control_name + "%" data-type=%"" + a_generator + "%" "
			if attached attrs as l_attrs then
				l_attributes.append (l_attrs)
			end
			if isolate then
				l_attributes.append (" data-isolation=%"1%"")
			end
			Result := render_tag_with_tagname (tag_name, body, l_attributes, l_css_classes_string)
		end

	js_class: READABLE_STRING_32
			-- The js_class is the name of the corresponding javascript class for this control. If this query is not redefined, it just
			-- returns the name of the Eiffel class. In case of customized controls, either the according javascript functionality has to
			-- be written in a coffeescript class of the same name or this query has to bee redefined and has to return the name of the
			-- control Eiffel class of which the javascript functionality should be inherited.
		do
			Result := generator
		end

feature -- Event handling

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- Method called if any callback received.
			-- In this method the callback can be routed to the event handler.
		require
			cname_is_not_empty: not cname.is_empty
		deferred
		end

feature -- Change

	set_isolation (p: BOOLEAN)
			-- Set the isolation state of this control
		do
			isolate := p
		end

	set_control_name_prefix (p: STRING_32)
			-- Set the control name prefix
		do
			control_name_prefix := p
		end

	set_control_id (d: INTEGER)
			-- Set the id of this control
		do
			control_id := d
		end

feature -- Properties

	isolate: BOOLEAN
			-- The isolation state of this control

	actions: JSON_ARRAY
			-- An array of actions to be carried out, e.g. display a modal (see tutorial for more information about this)

	control_id: INTEGER assign set_control_id
			-- The id of this control

	control_name: STRING_32
			-- The name of this control which is composed of the control name prefix and the id of the control
		do
			Result := control_name_prefix + control_id.out
		end

	control_name_prefix: STRING_32 assign set_control_name_prefix
			-- Used to avoid name conflicts since the children stateful controls of stateless controls are appended to the parent
			-- control state and therefore could have the same name (Stateless multi controls do not add a hierarchy level)

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
