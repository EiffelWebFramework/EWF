note
	description: "Summary description for {WSF_FORM_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control
		redefine
			add_control
		end

	WSF_VALIDATABLE

create
	make, make_with_label_width

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			make_with_label_width (2)
		end

	make_with_label_width (w: INTEGER)
		do
			make_multi_control
			tag_name := "form"
			label_width := w
			add_class ("form-horizontal")
		end

feature

	add_control (c: WSF_STATELESS_CONTROL)
		do
			Precursor (c)
			if attached {WSF_FORM_ELEMENT_CONTROL[ANY]} c as fec then
				fec.set_label_width (label_width)
			end
		end

feature -- Validation

	validate
			-- Perform form validation
		do
			is_valid := True
			across
				controls as c
			loop
				if attached {WSF_VALIDATABLE} c.item as elem then
					elem.validate
					if not elem.is_valid then
						is_valid := False
					end
				end
			end
		end

	is_valid: BOOLEAN
			-- Tells whether the last validation was valid

feature

	label_width: INTEGER

end
