note
	description: "Summary description for {CMS_FORM_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_SUBMIT_INPUT

inherit
	CMS_FORM_INPUT

create
	make,
	make_with_text

feature -- Access

	input_type: STRING = "submit"

end
