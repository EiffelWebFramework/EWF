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
			panel: WSF_MULTI_CONTROL
		do
			create textbox1.make ("txtBox1", "1")
			create textbox2.make ("txtBox2", "2")
			create button1.make ("sample_button1", "SUM")
			create textbox_result.make ("txtBox3", "")
			button1.set_click_event (agent handle_click)
			create panel.make ("panel")
			panel.add_control (textbox1)
			panel.add_control (textbox2)
			panel.add_control (button1)
			panel.add_control (textbox_result)
			control := panel
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
