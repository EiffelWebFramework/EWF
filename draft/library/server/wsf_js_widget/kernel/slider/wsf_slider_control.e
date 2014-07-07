note
	description: "[
		Represents the bootstraps's 'carousel'.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_SLIDER_CONTROL

inherit

	WSF_CONTROL
		rename
			make as make_control
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			make_control ("div")
			add_class ("carousel slide")
			create list.make_with_tag_name ("ol")
			list.add_class ("carousel-indicators")
			create slide_wrapper.make_with_tag_name ("div")
			slide_wrapper.add_class ("carousel-inner")
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
			-- Just implementation, nothing special to do here
		do
		end

	state: WSF_JSON_OBJECT
			-- Just implementation, nothing special to do here
		do
			create Result.make
		end

feature -- Callback

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- Just implementation, nothing special to do here
		do
		end

feature -- Rendering

	render: STRING_32
		local
			temp: STRING_32
		do
			temp := list.render
			temp.append (slide_wrapper.render)
			temp.append (render_tag_with_tagname ("a", "<span class=%"icon-prev%"></span>", "data-slide=%"prev%"", "left carousel-control"))
			temp.append (render_tag_with_tagname ("a", "<span class=%"icon-next%"></span>", "data-slide=%"next%"", "right carousel-control"))
			Result := render_tag (temp, "")
		end

feature -- Change

	add_image_with_caption (src, alt, a_caption: STRING_32)
			-- Add a new image to the slider with specified url, alternative text and caption
		local
			caption_control: detachable WSF_BASIC_CONTROL
		do
			if
				a_caption /= Void and then
				not a_caption.is_empty
			then
				create caption_control.make_with_body ("p", "", a_caption)
			end
			add_image_with_caption_control (src, alt, caption_control)
		end

	add_image_with_caption_control (src, alt: STRING_32; a_caption: detachable WSF_STATELESS_CONTROL)
			-- Add a new image to the slider, with specified url, alternative text and caption element
		do
			add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("img", "src=%"" + src + "%" alt=%"" + alt + "%"", "", ""), Void)
		end

	add_image (src, alt: STRING_32)
			-- Add a new image to the slider, with specified url and alternative text
		do
			add_image_with_caption (src, alt, "")
		end

	add_control (a_control: WSF_STATELESS_CONTROL; a_caption: detachable WSF_STATELESS_CONTROL)
			-- Add a new control to the slider
		local
			cl: STRING_32
			item: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create item.make
			item.add_class ("item")
			item.add_control (a_control)
			if a_caption /= Void then
				item.add_control (a_caption)
			end
			cl := ""
			if slide_wrapper.controls.count = 0 then
				cl := "active"
				item.add_class (cl)
			end
			slide_wrapper.add_control (item)
			list.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("li", "data-slide-to=%"" + list.controls.count.out + "%"", cl, ""));
		end

feature -- Properties

	list: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- List of slider links

	slide_wrapper: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- List of the single slides

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
