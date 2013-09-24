note
	description: "Summary description for {IMAGE_SLIDER_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMAGE_SLIDER_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature -- Implementation

	initialize_controls
		do
			Precursor
			create slider.make_slider ("myslider")
			slider.add_image ("http://www.placesmustseen.com/wp-content/uploads/2013/01/paris-eiffel-tower.jpg", "Eiffel Tower")
			control.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", " Image Slider Demo"))
			control.add_control (slider)
		end

	process
		do
		end

feature -- Properties

	slider: WSF_IMAGE_SLIDER_CONTROL

end
