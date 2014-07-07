note
	description: "[
		A very basic datepicker widget based on the datepicker from
		Stefan Petre (http://www.eyecon.ro/bootstrap-datepicker).
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DATE_PICKER_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control,
			make_with_tag_name as make_multi_control_with_tag_name
		select
			make_control
		end

	WSF_VALUE_CONTROL [STRING_32]
		undefine
			load_state,
			full_state,
			read_state_changes,
			make
		end

create
	make

feature {NONE} -- Initialization

	make (t: STRING_32)
			-- Make a date picker control with specified tag name (such as li) and menu title
		local
			span: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			make_multi_control_with_tag_name (t)
			add_class ("input-group date")
			create input.make ((create {DATE_TIME}.make_now).formatted_out ("[0]dd-[0]mm-yyyy"))
			input.add_class ("form-control")
			input.append_attribute ("size=%"16%" readonly=%"%"")
			add_control (input)
			create span.make_with_tag_name ("span")
			span.add_class ("input-group-addon add-on")
			span.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("span", "", "glyphicon glyphicon-calendar", ""))
			add_control (span)
		end

feature -- Implementation

	value: STRING_32
			-- The current value
		do
			Result := input.value
		end

	set_value (v: STRING_32)
			-- Set the current date (has to be in format dd-mm-yyyy)
		do
			input.set_value (v)
		ensure then
			value_set: input.value = v
		end

feature -- Properties

	input: WSF_INPUT_CONTROL
			-- The input control which is used to display the selected date

end
