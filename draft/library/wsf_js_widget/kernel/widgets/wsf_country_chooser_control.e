note
	description: "Summary description for {WSF_COUNTRY_CHOOSER_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_COUNTRY_CHOOSER_CONTROL

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
			-- Make a country chooser control with specified tag name (such as li) and menu title
		local
			temp: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			options: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			listbox: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			make_multi_control_with_tag_name (t)
			add_class ("bfh-selectbox bfh-countries")
			append_attribute ("data-country=%"US%" data-flags=%"true%"")
			create input.make ("")
			input.append_attribute ("type=%"hidden%"")
			add_control (input)
			create temp.make_with_tag_name ("a")
			temp.add_class ("bfh-selectbox-toggle")
			temp.append_attribute ("role=%"button%" data-toggle=%"bfh-selectbox%" href=%"#%"")
			temp.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("span", "data-option=%"%"", "bfh-selectbox-option input-medium", ""))
			temp.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("b", "style=%"border-top-color: black !important;%"", ""))
			add_control (temp)
			create options.make
			options.add_class ("bfh-selectbox-options")
			options.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("input", "type=%"text%"", "bfh-selectbox-filter", ""))
			create listbox.make
			listbox.append_attribute ("role=%"listbox%"")
			listbox.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("ul", "role=%"option%"", ""))
			options.add_control (listbox)
			add_control (options)
		end

feature -- Implementation

	value: STRING
		do
			Result := input.value
		end

feature -- Properties

	input: WSF_INPUT_CONTROL

end
