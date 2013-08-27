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
		do
			button := create {WSF_BUTTON_CONTROL}.make ("sample_button", "I'm a button")
			button.set_click_event(agent handle_click)
			control := button
		end

	handle_click(context: WSF_PAGE_CONTROL)
	do
		if attached {SAMPLE_PAGE} context as sp then
			sp.button.set_text("Hello World! (Ueeee)")
		end
	end

	process
		do
		end

	button: WSF_BUTTON_CONTROL
end
