note
	description: "Summary description for {SLIDER_PAGE}."
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
		do
			create slider.make
				--slider.add_control (form, Void)
				--slider.add_image ("http://www.placesmustseen.com/wp-content/uploads/2013/01/paris-eiffel-tower.jpg", "Eiffel Tower")
			slider.add_image ("http://31.media.tumblr.com/43f3edae3fb569943047077cddf93c79/tumblr_mtw7wdX9cm1st5lhmo1_1280.jpg", "car")
			slider.add_image ("http://31.media.tumblr.com/5b5ae35c4f88d4b80aeb21e36263c6e6/tumblr_mtw7mhZsCe1st5lhmo1_1280.jpg", "landscape")
			slider.add_image ("http://25.media.tumblr.com/403969159fb1642e67ed702f28e966e0/tumblr_muuig0890N1st5lhmo1_1280.jpg", "landscape")
			slider.add_image ("http://24.media.tumblr.com/d349779e7216167e7c0ca3af66817794/tumblr_mufrlh9WqW1st5lhmo1_1280.jpg", "landscape")

			Precursor
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
