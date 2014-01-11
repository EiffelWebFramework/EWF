note
	description: "Summary description for {WSF_DATETIME_PICKER_CONTROL}."
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

	WSF_VALUE_CONTROL [STRING]
		undefine
			load_state,
			full_state,
			read_state_changes,
			make
		end

create
	make

feature {NONE} -- Initialization

	make (t: STRING)
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

	value: STRING
		do
			Result := input.value
		end

	set_value (v: STRING)
		do
			input.set_value (v)
		end

feature -- Properties

	input: WSF_INPUT_CONTROL

end
