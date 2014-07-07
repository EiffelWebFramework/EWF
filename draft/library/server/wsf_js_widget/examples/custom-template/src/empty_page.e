note
	description: "Summary description for {EMPTY_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EMPTY_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature -- Initialization

	initialize_controls
		do
			Precursor
			navbar.set_active (1)
			-- Define colum 12/12
			main_control.add_column (12)

			-- Create button
			create button.make ("0")
			button.set_click_event (agent do
				button.set_text ((button.text.to_integer_32+1).out)
			end)
			--Add button control
			main_control.add_control (1,button)

		end

feature -- Implementation

	process
		do
		end
feature

	button: WSF_BUTTON_CONTROL

end
