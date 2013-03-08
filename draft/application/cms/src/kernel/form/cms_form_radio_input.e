note
	description: "Summary description for {CMS_FORM_RADIO_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_RADIO_INPUT

inherit
	CMS_FORM_SELECTABLE_INPUT

create
	make,
	make_with_value

feature -- Access

	input_type: STRING = "radio"

invariant

end
