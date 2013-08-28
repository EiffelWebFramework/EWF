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
			button1 := create {WSF_BUTTON_CONTROL}.make ("sample_button1", "I'm a button")
			button1.set_click_event (agent handle_click)
			button2 := create {WSF_BUTTON_CONTROL}.make ("sample_button2", "I'm a button2")
			button2.set_click_event (agent handle_click)
			create panel.make ("panel")
			panel.add_control (button1)
			panel.add_control (button2)
			control := panel
		end

	handle_click (context: WSF_PAGE_CONTROL)
		do
			if attached {SAMPLE_PAGE} context as sp then
				sp.button1.set_text ("Hello World! (Ueeee)")
				sp.button2.set_text ("Hi btn2")
			end
		end

	process
		do
		end

	button1: WSF_BUTTON_CONTROL

	button2: WSF_BUTTON_CONTROL

end
