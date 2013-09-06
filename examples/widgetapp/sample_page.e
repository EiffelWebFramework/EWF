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
		do
			create textbox1.make_text ("txtBox1", "1")
			create textbox2.make_text ("txtBox2", "2")
			create button1.make_button ("sample_button1", "SUM")
			create textbox_result.make_textarea ("txtBox3", "")
			button1.set_click_event (agent handle_click)
			create form.make_form_control ("panel")
			form.add_class ("form-horizontal")
			create cklist.make_checkbox_list_control ("categories")
			cklist.add_control (create {WSF_CHECKBOX_CONTROL}.make_checkbox ("net", "Network", "net"))
			cklist.add_control (create {WSF_CHECKBOX_CONTROL}.make_checkbox ("os", "Operating Systems", "os"))
			form.add_control (create {WSF_FORM_ELEMENT_CONTROL [STRING]}.make_form_element ("Number1", textbox1))
			form.add_control (create {WSF_FORM_ELEMENT_CONTROL [STRING]}.make_form_element ("Number2", textbox2))
			form.add_control (create {WSF_FORM_ELEMENT_CONTROL [LIST [STRING]]}.make_form_element ("Categories", cklist))
			form.add_control (button1)
			form.add_control (create {WSF_FORM_ELEMENT_CONTROL [STRING]}.make_form_element ("Result", textbox_result))
			control := form
		end

	handle_click
		local
			text: STRING
		do
			text := textbox1.text + " + " + textbox2.text + " = " + (textbox1.text.to_integer_16 + textbox2.text.to_integer_16).out
			across
				cklist.value as s
			loop
				text.append ("%N-" + s.item)
			end
			textbox_result.set_text (text)
		end

	process
		do
		end

	button1: WSF_BUTTON_CONTROL

	textbox1: WSF_TEXT_CONTROL

	textbox2: WSF_TEXT_CONTROL

	cklist: WSF_CHECKBOX_LIST_CONTROL

	textbox_result: WSF_TEXTAREA_CONTROL

end
