note
	description: "Summary description for {WSF_IMAGE_SLIDER_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_SLIDER_CONTROL

inherit

	WSF_CONTROL

create
	make_slider

feature {NONE} -- Initialization

	make_slider (n: STRING)
			-- Initialize with specified name
		do
			make_control (n, "div")
			add_class ("carousel slide")
			create list.make_with_tag_name (control_name + "_links", "ol")
			list.add_class ("carousel-indicators")
			create slide_wrapper.make_multi_control (control_name + "_wrapper")
			slide_wrapper.add_class ("carousel-inner")
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
		do
		end

	state: JSON_OBJECT
		do
			create Result.make
		end

feature -- Callback

	handle_callback (cname, event: STRING; event_parameter: detachable STRING)
		do
				-- Do nothing here
		end

feature -- Rendering

	render: STRING
		local
			temp: STRING
		do
			temp := list.render
			temp.append (slide_wrapper.render)
			temp.append (render_tag_with_tagname ("a", "<span class=%"icon-prev%"></span>", "href=%"#" + control_name + "%" data-slide=%"prev%"", "left carousel-control"))
			temp.append (render_tag_with_tagname ("a", "<span class=%"icon-next%"></span>", "href=%"#" + control_name + "%" data-slide=%"next%"", "right carousel-control"))
			Result := render_tag (temp, "")
		end

feature -- Change

	add_image_with_caption (src, alt, caption: STRING)
		local
			caption_control: detachable WSF_STATELESS_CONTROL
		do
			if attached caption as c then
				caption_control := create {WSF_BASIC_CONTROL}.make_with_body ("p", "", c)
			end
			add_image_with_caption_control (src, alt, caption_control)
		end

	add_image_with_caption_control (src, alt: STRING; caption: detachable WSF_STATELESS_CONTROL)
			-- Add a new image to the slider, with specified url, alternative text and caption element
		local
			item: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create item.make_multi_control (control_name + "_item" + slide_wrapper.controls.count.out)
			item.add_class ("item")
			item.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("img", "src=%"" + src + "%" alt=%"" + alt + "%"", "", ""))
			if attached caption as c then
				item.add_control (c)
			end
			add_control (item)
		end

	add_image (src, alt: STRING)
			-- Add a new image to the slider, with specified url and alternative text
		do
			add_image_with_caption (src, alt, "")
		end

	add_control (c: WSF_STATELESS_CONTROL)
			-- Add a new control to the slider
		local
			cl: STRING
		do
			cl := ""
			if slide_wrapper.controls.count = 0 then
				cl := "active"
				c.add_class (cl)
			end
			slide_wrapper.add_control (c)
			list.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("li", "data-target=%"#" + control_name + "%" data-slide-to=%"" + list.controls.count.out + "%"", cl, ""));
		end

feature -- Properties

	list: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- List of slider links

	slide_wrapper: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- List of the single slides

end
