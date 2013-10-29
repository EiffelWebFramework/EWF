note
	description: "Summary description for {IMAGE_SLIDER_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SLIDER_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature -- Implementation

	initialize_controls
		local
			form: WSF_FORM_CONTROL
		do
			Precursor
			create slider.make_slider ("myslider")
			create form.make_form_control ("sliderform")
			form.add_control (create {WSF_FORM_ELEMENT_CONTROL[STRING]}.make_form_element ("Input", create {WSF_INPUT_CONTROL}.make_input ("sliderformtext", "Test")))
			slider.add_control (form, Void)
			slider.add_image ("http://www.placesmustseen.com/wp-content/uploads/2013/01/paris-eiffel-tower.jpg", "Eiffel Tower")
			slider.add_image ("http://24.media.tumblr.com/0fcec9a7dde5b405a46b6fcda1ffad0c/tumblr_mtagkyYVIT1st5lhmo1_1280.jpg", "car")
			slider.add_image ("http://25.media.tumblr.com/d9e791508eb9a532aa7f258fa4e0fedc/tumblr_mtag5zve3g1st5lhmo1_1280.jpg", "landscape")
			control.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", " Image Slider Demo"))
			control.add_control (slider)
			navbar.set_active (4)
		end

	process
		do
		end

feature -- Properties

	slider: WSF_SLIDER_CONTROL

end
