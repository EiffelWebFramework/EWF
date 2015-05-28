note
	description: "[
		Represent attributes applicable to input type type=[number, range, date]
		The attributes: min, max, step.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=numeric attributes", "src=https://html.spec.whatwg.org/multipage/forms.html#common-input-element-attributes"

class
	WSF_FORM_FIELD_WITH_NUMERIC_ATTRIBUTE

feature -- Access

	min: detachable READABLE_STRING_32
			-- minimun value accepted by Current field.

	max: detachable READABLE_STRING_32
			-- maximun value accepted by Current field.

	step: detachable READABLE_STRING_32
			--  step is the increment that the value should adjust up or down, with the default step value being 1.

feature -- Element Change

	set_min (a_val: INTEGER)
			-- Set `min' with `a_val'.
		do
			set_min_string (a_val.out)
		ensure
			min_set: attached min as l_min implies l_min.same_string (a_val.out)
		end

	set_max (a_val: INTEGER)
			-- Set `max' with `a_val'.
		do
			set_max_string(a_val.out)
		ensure
			max_set: attached max as l_max implies l_max.same_string (a_val.out)
		end

	set_step (a_val: REAL)
			-- Set `step' with `a_val'.
		do
			set_step_string (a_val.out)
		ensure
			step_set: attached step as l_step implies l_step.same_string (a_val.out)
		end

	set_min_string (a_val: READABLE_STRING_32)
			-- Set `min' with `a_val'.
		do
			min := a_val
		ensure
			min_set: attached min as l_min implies l_min = a_val
		end

	set_max_string (a_val: READABLE_STRING_32)
			-- Set `max' with `a_val'.
		do
			max := a_val
		ensure
			max_set: attached max as l_max implies l_max = a_val
		end

	set_step_string (a_val: READABLE_STRING_32)
			-- Set `step' with `a_val'.
		do
			step := a_val
		ensure
			step_set: attached step as l_step implies l_step = a_val
		end


feature {NONE} -- Conversion

	append_numeric_input_attributes_to (a_target: STRING)
			-- append numeric attributes to a_target, if any.
		do
				--min
			if attached min as l_min then
				a_target.append (" min=%"")
				a_target.append ((create {HTML_ENCODER}).encoded_string (l_min))
				a_target.append_character ('%"')
			end

				--max
			if attached max as l_max then
				a_target.append (" max=%"")
				a_target.append ((create {HTML_ENCODER}).encoded_string (l_max))
				a_target.append_character ('%"')
			end

				--step
			if attached step as l_step then
				a_target.append (" step=%"")
				a_target.append ((create {HTML_ENCODER}).encoded_string (l_step))
				a_target.append_character ('%"')
			end
		end

end
