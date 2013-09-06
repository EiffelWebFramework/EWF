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
			read_state
		end

	WSF_VALIDATABLE

create
	make_form_element, make_form_element_with_validators

feature {NONE}

	make_form_element (a_label: STRING; c: WSF_VALUE_CONTROL [G])
		local
			a_validators: LINKED_LIST [WSF_VALIDATOR [G]]
		do
			create a_validators.make
			make_form_element_with_validators (a_label, c, a_validators)
		end

	make_form_element_with_validators (a_label: STRING; c: WSF_VALUE_CONTROL [G]; v: LINKED_LIST [WSF_VALIDATOR [G]])
		do
			make (c.control_name + "_container", "div")
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

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	load_state (new_states: JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			value_control.load_state (new_states)
		end

	set_state (new_state: JSON_OBJECT)
		do
			value_control.set_state (new_state)
		end

	read_state (states: JSON_OBJECT)
			-- Read states in subcontrols
		do
			Precursor (states)
			value_control.read_state (states)
		end

	read_state_changes (states: JSON_OBJECT)
			-- Read states_changes in subcontrols
		do
			Precursor (states)
			value_control.read_state_changes (states)
		end

	state: JSON_OBJECT
			--Read state
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
			Result.put (create {JSON_STRING}.make_json (value_control.control_name), create {JSON_STRING}.make_json ("value_control"))
			Result.put (validator_description, create {JSON_STRING}.make_json ("validators"))
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
			-- Pass callback to subcontrols
		do
			if equal (cname, control_name) then
				if event.is_equal ("validate") then
					validate
				end
			else
				value_control.handle_callback (cname, event)
			end
		end

feature --Implementation

	render: STRING
		local
			body: STRING
		do
			body := ""
			if not label.is_empty then
				body := "<label class=%"col-lg-2 control-label%" for=%"" + value_control.control_name + "%">" + label + "</label>"
			end
			body := body + "<div class=%"col-lg-10%">"
			body := body + value_control.render
			body := body + "</div>"
			Result := render_tag (body, "")
		end

feature -- Validation

	add_validator (v: WSF_VALIDATOR [G])
		do
			validators.extend (v)
		end

	set_error (e: STRING)
		do
			error := e
			state_changes.replace (create {JSON_STRING}.make_json (e), create {JSON_STRING}.make_json ("error"))
		end

	validate
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

feature

	value_control: WSF_VALUE_CONTROL [G]

	validators: LINKED_LIST [WSF_VALIDATOR [G]]

	label: STRING

	error: STRING

end
