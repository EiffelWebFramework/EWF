note
	description: "[
		Represents a standard html form. Provides facilities for
		validation.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_stateless_multi_control
		redefine
			add_control
		end

	WSF_VALIDATABLE

create
	make, make_with_label_width

feature {NONE} -- Initialization

	make
			-- Initialize with default label width 2
		do
			make_with_label_width (2)
		end

	make_with_label_width (w: INTEGER)
			-- Initialize with the specified label width measured in Bootstrap columns
		require
			w_in_range: w >= 0 and w <= 12
		do
			make_stateless_multi_control
			tag_name := "form"
			label_width := w
			add_class ("form-horizontal")
		ensure
			label_width_set: label_width = w
		end

feature

	add_control (c: WSF_STATELESS_CONTROL)
			-- Add control to this form
		do
			Precursor (c)
			if attached {WSF_FORM_ELEMENT_CONTROL [detachable ANY]} c as fec then
				fec.set_label_width (label_width)
			end
		ensure then
			control_added: controls.has (c)
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
			-- The label width in this form, measured in Bootstrap columns

invariant
	label_width_in_range: label_width >= 0 and label_width <= 12

end
