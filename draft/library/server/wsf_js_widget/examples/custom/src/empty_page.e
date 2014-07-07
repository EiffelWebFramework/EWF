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
			-- Bind custom.js
			add_javascript ("assets/custom.js")
			navbar.set_active (1)
			-- Define colum 12/12
			main_control.add_column (6)
			main_control.add_column (6)
			create chart.make
			chart.set_data (<<["Eiffel",100.0],["Java",20.0],["C++",40.0]>>)
			main_control.add_control (1,chart)

			-- Create button
			create button.make ("Load new dataset")
			button.set_click_event (agent do
				chart.set_data (<<["Eiffel",120.0],["Java",60.0],["C#",30.0],["Python",230.0]>>)
			end)
			--Add button control
			main_control.add_control (2,button)
		end

feature -- Implementation

	process
		do
		end
feature

	button: WSF_BUTTON_CONTROL

	chart: WSF_BARCHART_CONTROL

end
