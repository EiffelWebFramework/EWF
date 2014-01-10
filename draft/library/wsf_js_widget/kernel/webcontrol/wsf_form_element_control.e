note
	description: "Summary description for {WSF_FORM_ELEMENT_CONTROL}."
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

	make_without_border (a_label: detachable STRING; c: WSF_VALUE_CONTROL [G])
			-- Initialize form element control with a specific label (or 'Void' for no label) and value control
		do
			make_with_validators (a_label, False, c, create {ARRAYED_LIST [WSF_VALIDATOR [G]]}.make (0))
		end

	make (a_label: detachable STRING; c: WSF_VALUE_CONTROL [G])
			-- Initialize form element control with a specific label (or 'Void' for no label) and value control
		do
			make_with_validators (a_label, True, c, create {ARRAYED_LIST [WSF_VALIDATOR [G]]}.make (0))
		end

	make_with_validators (a_label: detachable STRING; show_border: BOOLEAN; c: WSF_VALUE_CONTROL [G]; v: LIST [WSF_VALIDATOR [G]])
			-- Initialize form element control with a specific label (or 'Void' for no label), value control and list of validators
		do
			make_control ("div")
			add_class ("form-group")
			if show_border then
				if not attached {WSF_VALUE_CONTROL [LIST [ANY]]} c then
					c.add_class ("form-control")
				else
					c.add_class ("form-control-static")
				end
			end
			label_width := 2
			value_control := c
			validators := v
			label := a_label
			error := ""
		end

feature -- Modify

	set_label_width (w: INTEGER)
			-- Set the label span (a value between 1 and 12 to specify the bootstrap column span or 0 for not displaying the label)
		do
			label_width := w
		end

feature -- Access

	value: G
		do
			Result := value_control.value
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	load_state (new_states: JSON_OBJECT)
			-- Pass new_states to subcontrols
		do
			Precursor (new_states)
			if attached {JSON_OBJECT} new_states.item ("controls") as ct and then attached {JSON_OBJECT} ct.item (value_control.control_name) as value_state then
				value_control.load_state (value_state)
			end
		end

	set_state (new_state: JSON_OBJECT)
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

	handle_callback (cname: LIST [STRING]; event: STRING; event_parameter: detachable ANY)
			-- Pass callback to subcontrols
		do
			if cname [1].same_string (control_name) then
				cname.go_i_th (1)
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

	render: STRING
			-- HTML Respresentation of this form element control
		local
			body: STRING
		do
			body := ""
			if attached label as l and then not l.is_empty then
				body.append ("<label class=%"col-lg-" + label_width.out + " control-label%" for=%"" + value_control.control_name + "%">" + l + "</label>")
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

	label: detachable STRING
			-- The label of this form element control

	error: STRING
			-- The error message that is displayed when client side validation fails

	label_width: INTEGER
			-- The bootstrap column span of the label of this form element control

end
