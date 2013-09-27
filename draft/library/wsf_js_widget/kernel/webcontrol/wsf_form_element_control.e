note
	description: "Summary description for {WSF_FORM_ELEMENT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_ELEMENT_CONTROL [G]

inherit

	WSF_CONTROL
		redefine
			read_state_changes,
			load_state,
			full_state
		end

	WSF_VALIDATABLE

create
	make_form_element, make_form_element_with_validators

feature {NONE} -- Initialization

	make_form_element (a_label: STRING; c: WSF_VALUE_CONTROL [G])
			-- Initialize form element control with a specific label and value control
		do
			make_form_element_with_validators (a_label, c, create {ARRAYED_LIST [WSF_VALIDATOR [G]]}.make (0))
		end

	make_form_element_with_validators (a_label: STRING; c: WSF_VALUE_CONTROL [G]; v: LIST [WSF_VALIDATOR [G]])
			-- Initialize form element control with a specific label, value control and list of validators
		do
			make_control (c.control_name + "_container", "div")
			add_class ("form-group")
			if attached {WSF_INPUT_CONTROL} c or attached {WSF_TEXTAREA_CONTROL} c then
				c.add_class ("form-control")
			end
			if attached {WSF_HTML_CONTROL} c then
				c.add_class ("form-control-static")
			end
			value_control := c
			validators := v
			label := a_label
			error := ""
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	load_state (new_states: WSF_JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			if attached {WSF_JSON_OBJECT} new_states.item ("controls") as ct and then attached {WSF_JSON_OBJECT} ct.item (value_control.control_name) as value_state then
				value_control.load_state (value_state)
			end
		end

	set_state (new_state: WSF_JSON_OBJECT)
			-- Set new state
		do
			value_control.set_state (new_state)
		end

	full_state: WSF_JSON_OBJECT
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
		do
			Precursor (states)
			value_control.read_state_changes (states)
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

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
			-- Pass callback to subcontrols
		do
			if cname.same_string (control_name) then
				if event.same_string ("validate") then
					validate
				end
			else
				value_control.handle_callback (cname, event, event_parameter)
			end
		end

feature -- Implementation

	render: STRING
			-- HTML Respresentation of this form element control
		local
			body: STRING
		do
			body := ""
			if not label.is_empty then
				body.append ("<label class=%"col-lg-2 control-label%" for=%"" + value_control.control_name + "%">" + label + "</label>")
			end
			body.append ("<div class=%"col-lg-10%">")
			body.append (value_control.render)
			body.append ("</div>")
			Result := render_tag (body, "")
		end

feature -- Validation

	add_validator (v: WSF_VALIDATOR [G])
			-- Add an additional validator that will check the input of the value control of this form element control on validation
		do
			validators.extend (v)
		end

	set_error (e: STRING)
			-- Set the error message that will be displayed upon failure of client side validation
		do
			error := e
			state_changes.replace (create {JSON_STRING}.make_json (e), "error")
		end

	validate
			-- Perform validation
		local
			current_value: G
		do
			current_value := value_control.value
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

	label: STRING
			-- The label of this form element control

	error: STRING
			-- The error message that is displayed when client side validation fails

end
