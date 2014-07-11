note
	description: "[
		A container class which encapsulates a form element (like input
		fields) and, optionally, the corresponding validators and an
		optional label.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_ELEMENT_CONTROL [G]

inherit

	WSF_CONTROL
		rename
			make as make_control
		redefine
			read_state_changes,
			load_state,
			full_state
		end

	WSF_VALIDATABLE

create
	make, make_without_border, make_with_validators

feature {NONE} -- Initialization

	make_without_border (a_label: detachable STRING_32; a_control: WSF_VALUE_CONTROL [G])
			-- Initialize Current form element control with a specific label
			-- (or 'Void' for no label) and value control `a_control'.
		do
			make_with_validators (a_label, False, a_control, create {ARRAYED_LIST [WSF_VALIDATOR [G]]}.make (0))
		end

	make (a_label: detachable STRING_32; a_control: WSF_VALUE_CONTROL [G])
			-- Initialize Current form element control with a specific label
			-- (or 'Void' for no label) and value control `a_control'.
		do
			make_with_validators (a_label, True, a_control, create {ARRAYED_LIST [WSF_VALIDATOR [G]]}.make (0))
		end

	make_with_validators (a_label: detachable STRING_32; show_border: BOOLEAN; a_control: WSF_VALUE_CONTROL [G]; a_validators: LIST [WSF_VALIDATOR [G]])
			-- Initialize Current form element control with a specific label (or 'Void' for no label),
			-- value control `a_control' and list of validators `a_validators'
		do
			make_control ("div")
			add_class ("form-group")
			if show_border then
				if attached {WSF_VALUE_CONTROL [LIST [ANY]]} a_control then
					a_control.add_class ("form-control-static")
				else
					a_control.add_class ("form-control")
				end
			end
			label_width := 2
			value_control := a_control
			validators := a_validators
			label := a_label
			error := ""
		end

feature -- Modify

	set_label_width (w: INTEGER)
			-- Set the label span (a value between 1 and 12 to specify the bootstrap column span or 0 for not displaying the label)
		do
			label_width := w
		ensure
			label_width_set: label_width = w
		end

feature -- Access

	value: G
			-- Current value of this form element's value control
		do
			Result := value_control.value
		ensure
			result_set: Result = value_control.value
		end

	set_value (v: G)
			-- Set the value of this form element's value control
		do
			value_control.set_value (v)
		ensure
			value_set: value_control.value = v
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	load_state (new_states: JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			if
				attached {JSON_OBJECT} new_states.item ("controls") as ct and then
				attached {JSON_OBJECT} ct.item (value_control.control_name) as value_state
			then
				value_control.load_state (value_state)
			end
		end

	set_state (new_state: JSON_OBJECT)
			-- Set new state
		do
			value_control.set_state (new_state)
		end

	full_state: WSF_JSON_OBJECT
			-- The full state of this form
		local
			controls_state: WSF_JSON_OBJECT
		do
			Result := Precursor
			create controls_state.make
			controls_state.put (value_control.full_state, value_control.control_name)
			Result.put (controls_state, "controls")
		end

	read_state_changes (states: WSF_JSON_OBJECT)
			-- Read states_changes in subcontrols
		local
			sub_states: WSF_JSON_OBJECT
			control_state: WSF_JSON_OBJECT
		do
			Precursor (states)
			create sub_states.make
			value_control.read_state_changes (sub_states)
			if sub_states.count > 0 then
				if attached {JSON_OBJECT} states.item (control_name) as changes then
					changes.put (sub_states, "controls")
				else
					create control_state.make
					control_state.put (sub_states, "controls")
					states.put (control_state, control_name)
				end
			end
		end

	state: WSF_JSON_OBJECT
			-- Read state
		local
			validator_description: JSON_ARRAY
		do
			create Result.make
			create validator_description.make_array
			across
				validators as v
			loop
				validator_description.add (v.item.state)
			end
			Result.put_string (value_control.control_name, "value_control")
			Result.put (validator_description, "validators")
		end

feature -- Event handling

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- Pass callback to subcontrols
		do
			if cname.first.same_string (control_name) then
				cname.start
				cname.remove
				if cname.is_empty then
					if event.same_string ("validate") then
						validate
					end
				else
					value_control.handle_callback (cname, event, event_parameter)
				end
			end
		end

feature -- Implementation

	render: STRING_32
			-- HTML Respresentation of this form element control
		local
			body: STRING_32
		do
			create body.make_empty
			if attached label as l_label and then not l_label.is_empty then
				body.append ("<label class=%"col-lg-" + label_width.out + " control-label%" for=%"" + value_control.control_name + "%">" + l_label + "</label>")
				body.append ("<div class=%"col-lg-" + (12 - label_width).out + "%">")
			else
				body.append ("<div class=%"col-lg-12%">")
			end
			body.append (value_control.render)
			body.append ("</div>")
			Result := render_tag (body, "")
		end

feature -- Validation

	add_validator (v: WSF_VALIDATOR [G])
			-- Add an additional validator that will check the input of the value control of this form element control on validation
		do
			validators.extend (v)
		ensure
			validator_added: validators.has (v)
		end

	set_error (e: STRING_32)
			-- Set the error message that will be displayed upon failure of client side validation
		do
			error := e
			state_changes.replace (create {JSON_STRING}.make_json_from_string_32 (e), "error")
		ensure
			error_set: error.same_string (e)
		end

	validate
			-- Perform validation
		local
			current_value: G
		do
			current_value := value
			is_valid := True
			across
				validators as c
			until
				not is_valid
			loop
				if not c.item.is_valid (current_value) then
					is_valid := False
					set_error (c.item.error)
				end
			end
			if is_valid then
				set_error ("")
			end
		end

	is_valid: BOOLEAN
			-- Tells whether the last validation was successful or not

feature -- Properties

	value_control: WSF_VALUE_CONTROL [G]
			-- The value control associated with this form element control

	validators: LIST [WSF_VALIDATOR [G]]
			-- The validators which check the input when validaton is performed

	label: detachable STRING_32
			-- The label of this form element control

	error: STRING_32
			-- The error message that is displayed when client side validation fails

	label_width: INTEGER
			-- The bootstrap column span of the label of this form element control

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
