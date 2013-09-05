note
	description: "Summary description for {WSF_FORM_ELEMENT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_ELEMENT_CONTROL [G]

inherit

	WSF_CONTROL

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
			c.add_class ("form-control")
			value_control := c
			validators := v
			label := a_label
			error := ""
		end

feature

	is_valid (): BOOLEAN
		do
			Result := True
			across
				validators as c
			until
				not Result
			loop
				if not c.item.validate (value_control.value) then
					Result := False
				end
			end
		end

feature --Implementation

	set_state (new_state: JSON_OBJECT)
		do
			value_control.set_state (new_state)
		end

	state: JSON_OBJECT
		do
			Result := value_control.state
		end

	handle_callback (cname, event: STRING_8)
		do
			value_control.handle_callback (cname, event)
		end

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

feature

	value_control: WSF_VALUE_CONTROL [G]

	validators: LINKED_LIST [WSF_VALIDATOR [G]]

	label: STRING

	error: STRING

end
