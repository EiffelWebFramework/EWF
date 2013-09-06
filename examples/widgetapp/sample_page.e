note
	description: "Summary description for {SAMPLE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAMPLE_PAGE

inherit

	WSF_PAGE_CONTROL

create
	make

feature

	initialize_controls
		local
			form: WSF_FORM_CONTROL
			n1_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			n2_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			cats_container: WSF_FORM_ELEMENT_CONTROL [LIST [STRING]]
		do
			create textbox1.make_input ("txtBox1", "1")
			create textbox2.make_input ("txtBox2", "2")
			create button1.make_button ("sample_button1", "SUM")
			create textbox_result.make_html ("txtBox3","p", "")
			button1.set_click_event (agent handle_click)
			button1.add_class ("col-lg-offset-2")
			create form.make_form_control ("panel")
			form.add_class ("form-horizontal")
			create cklist.make_checkbox_list_control ("categories")
			cklist.add_control (create {WSF_CHECKBOX_CONTROL}.make_checkbox ("net", "Network", "net"))
			cklist.add_control (create {WSF_CHECKBOX_CONTROL}.make_checkbox ("os", "Operating Systems", "os"))
			create n1_container.make_form_element ("Number1", textbox1)
			n1_container.add_validator (create {WSF_DECIMAL_VALIDATOR}.make_decimal_validator ("Invalid Number"))
			n1_container.add_validator (create {OWN_VALIDATOR}.make_own)
			create n2_container.make_form_element ("Number2", textbox2)
			n2_container.add_validator (create {WSF_DECIMAL_VALIDATOR}.make_decimal_validator ("Invalid Number"))
			form.add_control (n1_container)
			form.add_control (n2_container)
			create cats_container.make_form_element ("Categories", cklist)
			cats_container.add_validator (create {WSF_MIN_VALIDATOR[STRING]}.make_min_validator (1,"Choose at least one category"))
			cats_container.add_validator (create {WSF_MAX_VALIDATOR[STRING]}.make_max_validator (1,"Choose at most one category"))

			form.add_control (cats_container)
			form.add_control (button1)

			form.add_control (create {WSF_FORM_ELEMENT_CONTROL [STRING]}.make_form_element ("Result", textbox_result))
			control := form
		end

	handle_click
		local
			text: STRING
		do
			if attached {WSF_FORM_CONTROL} control as form then
				form.validate
				if form.is_valid then
					text := textbox1.text + " + " + textbox2.text + " = " + (textbox1.text.to_integer_64 + textbox2.text.to_integer_64).out
					text.append ("<ul>")
					across
						cklist.value as s
					loop
						text.append ("<li>" + s.item + "</li>")
					end
					text.append ("</ul>")
					textbox_result.set_html (text)
				else
					textbox_result.set_html ("VALIDATION ERROR")
				end
			end
		end

	process
		do
		end

	button1: WSF_BUTTON_CONTROL

	textbox1: WSF_INPUT_CONTROL

	textbox2: WSF_INPUT_CONTROL

	cklist: WSF_CHECKBOX_LIST_CONTROL

	textbox_result: WSF_HTML_CONTROL

end
