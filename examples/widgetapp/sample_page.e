note
	description: "Summary description for {SAMPLE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAMPLE_PAGE

inherit

	WSF_PAGE_CONTROL
		redefine
			initialize_controls,
			process
		end

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
			create textbox_result.make_text ("txtBox3", "")
			button1.set_click_event (agent handle_click)
			create form.make_form_control ("panel")
			form.add_control (create {WSF_FORM_ELEMENT_CONTROL[STRING]}.make_form_element("Number1",textbox1))
			form.add_control (textbox2)
			form.add_control (button1)
			form.add_control (textbox_result)
			control := form
		end

	handle_click
		do
			textbox_result.set_text (textbox1.text + " + " + textbox2.text + " = " + (textbox1.text.to_integer_16 + textbox2.text.to_integer_16).out)
		end

	process
		do
		end

	button1: WSF_BUTTON_CONTROL

	textbox1: WSF_TEXT_CONTROL

	textbox2: WSF_TEXT_CONTROL

	textbox_result: WSF_TEXT_CONTROL

end
