note
	description: "Summary description for {CMS_FORM_PASSWORD_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_PASSWORD_INPUT

inherit
	CMS_FORM_INPUT
		redefine
			input_type
		end

create
	make,
	make_with_text

feature -- Access

	input_type: STRING
		once
			Result := "password"
		end

end
